//
//  SearchStore.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-29.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchStore {
  typealias State = SearchState
  typealias Action = SearchActions
  
  let service: NetworkClientProtocol
  
  init(service: NetworkClientProtocol = NetworkClient()) {
    self.service = service
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .search(query):
        guard !query.isEmpty else {
          state.phase = .ready
          return .none
        }
        state.phase = .loading
        return .run { send in
          do {
            let searchResult = try await service.send(SearchShowsRequest(query: query))
            try await Task.sleep(for: .seconds(2))
            await send(.searchSuccess(searchResult.map(\.show)))
          } catch {
            await send(.searchFailed(error))
          }
        }
      case let .searchSuccess(shows):
        if !shows.isEmpty {
          state.phase = .showingSearchResult
          state.showsSearchResult = shows
        } else {
          state.phase = .searchResultEmpty
          state.showsSearchResult = []
        }
        return .none
      case .searchFailed:
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
