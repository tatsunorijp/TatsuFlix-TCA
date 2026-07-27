//
//  HomeView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
  @Bindable var store: StoreOf<HomeStore>
  
  var body: some View {
    switch store.phase {
    case .ready:
      readyView
    case .loading:
      LoadingView()
        .task {
          store.send(.fetchShows)
        }
    case .failed:
      failedView
    }
  }
  
  private var failedView: some View {
    Text("Something went wrong")
  }
  
  private var readyView: some View {
    return NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      List(store.shows) { show in
        VStack {
          Text(show.name)
          Text(show.summary ?? "")
            .padding(.bottom, 44)
        }
        .onTapGesture {
          store.send(.showDetails(for: show))
        }
      }
    } destination: { store in
      switch store.case {
      case let .showDetails(store):
        ShowDetailsView(store: store)
      }
    }
  }
}

// Preview Test
struct HomeViewPreview: View {
  var body: some View {
    NavigationStack {
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

#Preview {
  HomeViewPreview()
}
