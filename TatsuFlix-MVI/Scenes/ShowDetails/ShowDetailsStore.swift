//
//  ShowDetailsStore.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ShowDetailsStore {
  typealias State = ShowDetailsState
  typealias Action = ShowDetailsActions
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .saveFavorite:
        return .none
      case .removeFavorite:
        return .none
      case .seeEpisodesDetails:
        return .none
      }
    }
  }
  
}
