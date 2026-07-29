//
//  SearchNavigationStack.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation
import SwiftUI
import ComposableArchitecture

enum SearchRouterPaths: Hashable {
  case search
}

struct SearchNavigationStack: View {
  @Environment(Router.self) private var router
  
  var body: some View {
    @Bindable var router = router
    
    NavigationStack(path: $router.search) {
      SearchView(
        store: Store(initialState: SearchStore.State(
          searchText: "",
          showsSearchResult: []
        )) {
          SearchStore(service: NetworkClient())
        }
      )
      .navigationDestination(for: SearchRouterPaths.self) { route in
        switch route {
        case .search:
          SearchView(
            store: Store(initialState: SearchStore.State(
              searchText: "",
              showsSearchResult: []
            )) {
              SearchStore(service: NetworkClient())
            }
          )
        }
      }
    }
  }
}

// Preview Test
struct SearchNavigationStackPreview: View {
  var body: some View {
    SearchNavigationStack()
      .environment(Router())
  }
}

#Preview {
  SearchNavigationStackPreview()
}


