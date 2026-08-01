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
  typealias Action = ShowDetailsAction

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .saveFavorite:
        return .none
      case .removeFavorite:
        return .none
      case let .presentEpisodesDetails(showId):
        state.destination = .showDetails(.init(showId: showId))
        return .none
      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}
