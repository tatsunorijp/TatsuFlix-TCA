//
//  ShowDetailsState.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation
import ComposableArchitecture

extension ShowDetailsStore {
  @ObservableState
  struct ShowDetailsState {
    var phase: ShowDetailsPhase
    var show: ShowResponse
  }
  
  enum ShowDetailsPhase: Equatable {
    case ready
  }
  
  enum ShowDetailsActions {
    case saveFavorite
    case removeFavorite
    case seeEpisodesDetails
  }
}
