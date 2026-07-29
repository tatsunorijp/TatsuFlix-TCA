//
//  SearchState.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-29.
//

import Foundation
import ComposableArchitecture

extension SearchStore {
  @ObservableState
  struct SearchState {
    var phase: SearchPhase = .ready
    var searchText: String
    var showsSearchResult: [ShowResponse]
  }

  enum SearchPhase: Equatable {
    case ready
    case loading
    case failed
    case searchResultEmpty
    case showingSearchResult
  }
  
  enum SearchActions {
    case search(String)
    case searchSuccess([ShowResponse])
    case searchFailed(Error)
  }
}
