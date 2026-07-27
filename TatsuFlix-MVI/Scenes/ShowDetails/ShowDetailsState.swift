//
//  ShowDetailsState.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation
import ComposableArchitecture

extension ShowDetailsStore {
  @Reducer
  enum Destination {
    case showDetails(EpisodesStore)
  }

  @ObservableState
  struct ShowDetailsState {
    var phase: Phase
    var show: ShowResponse
    @Presents var destination: Destination.State?
  }
  
  enum Phase: Equatable {
    case ready
  }
  
  @CasePathable
  enum ShowDetailsAction {
    case saveFavorite
    case removeFavorite
    case presentEpisodesDetails(showId: String)
    case destination(PresentationAction<Destination.Action>)
  }
}
