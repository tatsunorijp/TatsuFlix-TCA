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
  
  let columns: [GridItem] = Array(
    repeating: .init(.flexible()), count: 2
  )
  
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
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(store.shows, id: \.id) { show in
            ShowCardView(show: show)
              .onTapGesture {
                store.send(.showDetails(for: show))
              }
          }
        }
        .padding(.top)
      }
      .navigationTitle("TatsuFlix")
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
                HomeStore()
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
