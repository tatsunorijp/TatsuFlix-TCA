//
//  EpisodesView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import SwiftUI
import ComposableArchitecture

struct EpisodesView: View {
  @Bindable var store: StoreOf<EpisodesStore>
  
  var body: some View {
    switch store.phase {
    case .ready:
      readyView
    case .loading:
      LoadingView()
        .task {
          store.send(.fetchEpisodes)
        }
    case .error:
      Text("Something went wrong")
    }
  }

  private var readyView: some View {
    List(store.episodes) { episode in
      VStack {
        Text(episode.name)
        Text("\(episode.number)")
        Text("\(episode.season)")
      }
    }
  }
}

#Preview {
  EpisodesView(
    store: Store(
      initialState: EpisodesStore.State(
        showId: "44778"
      ),
      reducer: {
        EpisodesStore(service: NetworkClient())
      }
    )
  )
}
