//
//  SearchPresentation.swift
//  TatsuFlix-TCA
//
//  Created by Wellington Tatsunori Asahide on 2026-08-25.
//

import Foundation
import ComposableArchitecture

// Used by App Intents and can also help/support deep links in the future.
struct SearchPresentation: Identifiable {
  let id = UUID()
  let store: StoreOf<SearchStore>

  init(query: String) {
    let store = Store(initialState: SearchStore.State(
      searchText: "",
      showsSearchResult: []
    )) {
      SearchStore(service: NetworkClient())
    }

    self.store = store
    store.send(.search(query))
  }
}
