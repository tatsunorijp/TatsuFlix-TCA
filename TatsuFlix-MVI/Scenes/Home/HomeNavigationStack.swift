//
//  HomeNavigationStack.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-25.
//

import Foundation
import SwiftUI
import ComposableArchitecture

enum HomeRouterPaths: Hashable {
  case home
  case movieDetails
}

struct HomeNavigationStack: View {
  @Environment(Router.self) private var router
  
  var body: some View {
    @Bindable var router = router
    
    NavigationStack(path: $router.home) {
      HomeView(
        store: Store(initialState: HomeStore.State(
          shows: []
        )) {
          HomeStore(service: NetworkClient())
        }
      )
        .navigationDestination(for: HomeRouterPaths.self) { route in
          switch route {
          case .home:
            HomeView(
              store: Store(initialState: HomeStore.State(
                shows: []
              )) {
                HomeStore(service: NetworkClient())
              }
            )
          case .movieDetails:
            Text("Movie details")
          }
        }
    }
  }
}

// Preview Test
struct HomeNavigationStackPreview: View {
  var body: some View {
    HomeNavigationStack()
      .environment(Router())
  }
}

#Preview {
  HomeNavigationStackPreview()
}
