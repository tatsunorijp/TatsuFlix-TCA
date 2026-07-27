//
//  EpisodesState.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation
import ComposableArchitecture

extension EpisodesStore {
  @ObservableState
  struct EpisodesState {
    var showId: String
    var phase: EpisodesPhase = .loading
    var showSeasons: [ShowSeason] = []
  }
  
  enum EpisodesPhase: Equatable {
    case ready
    case loading
    case error
  }
  
  enum EpisodesAction {
    case fetchEpisodes
    case fetchEpisodesCompleted([EpisodeResponse])
    case fetchEpisodesFailed(Error)
  }
}
