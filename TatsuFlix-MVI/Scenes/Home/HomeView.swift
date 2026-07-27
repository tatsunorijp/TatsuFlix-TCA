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
            VStack {
              AsyncImageView(urlString: show.image?.medium)
                .frame(width: 100, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                HeadlineText(show.name, isBold: true)
                HStack {
                  BodyText("Rating")
                  BodyText(String(format: "%.2f", show.rating.average ?? 0.0))
                }
            }
            .onTapGesture {
              store.send(.showDetails(for: show))
            }
            .padding(.top, 16)
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
