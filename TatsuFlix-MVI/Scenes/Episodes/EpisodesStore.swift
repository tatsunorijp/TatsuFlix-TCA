//
//  EpisodesStore.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct EpisodesStore {
  typealias State = EpisodesState
  typealias Action = EpisodesAction
  
  let service: NetworkClient
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchEpisodes:
        state.phase = .loading
        return .run { [showId = state.showId] send in
          do {
            let episodes = try await service.send(EpisodesRequest(showId: showId))
            try await Task.sleep(for: .seconds(2))
            await send(.fetchEpisodesCompleted(episodes))
          } catch {
            await send(.fetchEpisodesFailed(error))
          }
        }
      case let .fetchEpisodesCompleted(episodes):
        state.episodes = episodes
        state.phase = .ready
        return .none
      case .fetchEpisodesFailed:
        state.phase = .error
        return .none
      }
    }
  }
}
