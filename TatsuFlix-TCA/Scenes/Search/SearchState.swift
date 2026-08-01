//
//  SearchState.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-29.
//

import Foundation
import ComposableArchitecture

extension SearchStore {
  @Reducer
  enum Path {
    case showDetails(ShowDetailsStore)
  }

  @ObservableState
  struct SearchState {
    var phase: SearchPhase = .ready
    var searchText: String
    var showsSearchResult: [ShowResponse]
    var path = StackState<Path.State>()
  }

  enum SearchPhase: Equatable {
    case ready
    case loading
    case failed
    case searchResultEmpty
    case showingSearchResult
  }
  
  @CasePathable
  enum SearchActions {
    case search(String)
    case searchSuccess([ShowResponse])
    case searchFailed(Error)
    case showDetails(for: ShowResponse)
    case path(StackAction<Path.State, Path.Action>)
  }
}
