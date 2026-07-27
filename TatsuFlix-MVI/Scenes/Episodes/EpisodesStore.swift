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
  
  let service: NetworkClientProtocol
  
  init(service: NetworkClientProtocol = NetworkClient()) {
    self.service = service
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchEpisodes:
        fetchEpisodes(state: &state)
      case let .fetchEpisodesCompleted(episodes):
        fetchEpisodesCompleted(state: &state, episodes)
      case let .fetchEpisodesFailed(error):
        fetchEpisodesFailed(state: &state, error)
      }
    }
  }

  private func fetchEpisodes(state: inout State) -> Effect<Action> {
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
  }

  private func fetchEpisodesCompleted(
    state: inout State,
    _ episodes: [EpisodeResponse]
  ) -> Effect<Action> {
    var seasons: [ShowSeason] = []
    let numberOfSeasons = episodes.last?.season ?? 0
    for i in 1...numberOfSeasons {
      seasons.insert(
        ShowSeason(
          id: i,
          seasonNumber: i,
          episodes: episodes.filter { $0.season == i}
        ),
        at: seasons.count
      )
    }
    
    state.showSeasons = seasons
    state.phase = .ready
    return .none
  }

  private func fetchEpisodesFailed(
    state: inout State,
    _ error: Error
  ) -> Effect<Action> {
    state.phase = .error
    return .none
  }
}
