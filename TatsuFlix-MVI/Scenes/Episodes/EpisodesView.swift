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
  @State private var expandedSeasonIds = Set<Int>()
  
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
    List(store.showSeasons) { season in
      Button {
        toggleSeason(season.id)
      } label: {
        HStack {
          HeadlineText("Season \(season.seasonNumber)", isBold: true)
            .padding(.top, Tokens.Spacing.small.rawValue)
            .padding(.bottom, Tokens.Spacing.small.rawValue)
          Spacer()
          Image(systemName: "chevron.down")
            .rotationEffect(.degrees(isSeasonExpanded(season.id) ? 180 : 0))
            .animation(.easeInOut(duration: 0.2), value: isSeasonExpanded(season.id))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      
      
      if isSeasonExpanded(season.id) {
        ForEach(season.episodes) { episode in
          HStack(spacing: Tokens.Spacing.medium.rawValue) {
            AsyncImageView(urlString: episode.image?.medium)
              .frame(width: 100, height: 60)
            VStack(alignment: .leading) {
              HeadlineText("\(episode.season).\(episode.number) \(episode.name)")
              FootnoteText(episode.summary?.removeHTMLTags() ?? "")
                .lineLimit(4)
            }
          }
          .transition(isSeasonExpanded(season.id) ? .move(edge: .bottom) : .move(edge: .top))
        }
      }
    }
  }
  
  private func toggleSeason(_ seasonId: Int) {
    withAnimation(.easeInOut(duration: 0.25)) {
      if expandedSeasonIds.contains(seasonId) {
        expandedSeasonIds.remove(seasonId)
      } else {
        expandedSeasonIds.insert(seasonId)
      }
    }
  }
  
  private func isSeasonExpanded(_ seasonId: Int) -> Bool {
    expandedSeasonIds.contains(seasonId)
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
