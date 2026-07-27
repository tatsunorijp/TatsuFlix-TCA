//
//  HomeStore.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeStore {
  typealias State = HomeState
  typealias Action = HomeActions

  let service: NetworkClientProtocol
  
  init(service: NetworkClientProtocol = NetworkClient()) {
    self.service = service
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchShows:
        state.phase = .loading
        return .run { [page = state.page] send in
          do {
            let newShows = try await service.send(GetShowsRequest(page: page))
            try await Task.sleep(for: .seconds(3))
            await send(.fetchShowsCompleted(newShows))
          } catch {
            await send(.fetchShowsFailed(error))
          }
          
        }
      case let .fetchShowsCompleted(receivedShows):
        state.phase = .ready
        state.shows = receivedShows
        return .none
      case .fetchShowsFailed:
        state.phase = .failed
        return .none
      case let .showDetails(show):
        state.path.append(.showDetails(.init(phase: .ready, show: show)))
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
