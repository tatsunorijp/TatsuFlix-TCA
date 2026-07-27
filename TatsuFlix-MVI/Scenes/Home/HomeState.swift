//
//  HomeState.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation
import ComposableArchitecture

extension HomeStore {
  @Reducer
  enum Path {
    case showDetails(ShowDetailsStore)
  }
  
  @ObservableState
  struct HomeState {
    var phase: HomePhase = .loading
    var shows: [ShowResponse]
    var page = 1
    var path = StackState<Path.State>()
  }
  
  enum HomePhase: Equatable {
    case loading
    case ready
    case failed
  }
  
  @CasePathable
  enum HomeActions: Equatable {
    case fetchShows
    case fetchShowsCompleted([ShowResponse])
    case fetchShowsFailed(Error)
    case showDetails(for: ShowResponse)
    case path(StackAction<Path.State, Path.Action>)
    
    // AI Generated - How cool is that?!
    static func == (lhs: HomeActions, rhs: HomeActions) -> Bool {
      switch (lhs, rhs) {
      case (.fetchShows, .fetchShows):
        return true
      case let (.fetchShowsCompleted(lhsShows), .fetchShowsCompleted(rhsShows)):
        return lhsShows == rhsShows
      case let (.fetchShowsFailed(lhsError), .fetchShowsFailed(rhsError)):
        let lhsNSError = lhsError as NSError
        let rhsNSError = rhsError as NSError
        return lhsNSError.domain == rhsNSError.domain
          && lhsNSError.code == rhsNSError.code
          && lhsNSError.localizedDescription == rhsNSError.localizedDescription
      case let (.showDetails(lhsShow), .showDetails(rhsShow)):
        return lhsShow == rhsShow
      case (.path, .path):
        return false
      default:
        return false
      }
    }
    // End AI generation
  }
}
