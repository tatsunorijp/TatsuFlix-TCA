//
//  SearchStore.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-29.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SearchStore {
  typealias State = SearchState
  typealias Action = SearchActions

  private nonisolated enum CancelID: Hashable, Sendable {
    case search
  }

  @Dependency(\.continuousClock) private var clock
  
  let service: NetworkClientProtocol
  
  init(service: NetworkClientProtocol = NetworkClient()) {
    self.service = service
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .search(searchText):
        guard searchText != state.searchText else {
          return .none
        }

        state.searchText = searchText
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
          state.phase = .ready
          state.showsSearchResult = []
          return .cancel(id: CancelID.search)
        }

        return .run { send in
          do {
            try await clock.sleep(for: .seconds(1))
            // TCA state can only be mutated synchronously in the reducer,
            // so this action transitions the state after the debounce.
            await send(.searchStarted)

            let searchResult = try await service.send(SearchShowsRequest(query: query))
            await send(.searchSuccess(searchResult.map(\.show)))
          } catch {
            // NetworkClient may wrap a cancellation in ApiError.unknown.
            guard !Task.isCancelled else { return }
            await send(.searchFailed(error))
          }
        }
        .cancellable(id: CancelID.search, cancelInFlight: true)
      case .searchStarted:
        state.phase = .loading
        return .none
      case let .searchSuccess(shows):
        if !shows.isEmpty {
          state.phase = .showingSearchResult
          state.showsSearchResult = shows
        } else {
          state.phase = .searchResultEmpty
          state.showsSearchResult = []
        }
        return .none
      case .searchFailed:
        state.phase = .failed
        return .none
      case let .showDetails(show):
        state.path.append(.showDetails(.init(phase: .ready, show: show)))
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
