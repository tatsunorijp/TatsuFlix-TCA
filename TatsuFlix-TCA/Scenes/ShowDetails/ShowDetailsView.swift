//
//  ShowDetailsView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import SwiftUI
import ComposableArchitecture

struct ShowDetailsView: View {
  @Bindable var store: StoreOf<ShowDetailsStore>
  
  var body: some View {
    let show = store.show
    
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        AsyncImageView(urlString: show.image?.original, contentMode: .fill)
          .frame(maxWidth: .infinity)
          .frame(height: 280)
          .clipped()
          .clipShape(RoundedRectangle(cornerRadius: 10))
        
        DetailsSections {
          TitleText(show.name, isBold: true)
          BodyText(show.summary?.removeHTMLTags() ?? "")
            .padding(.bottom)
          
          if !show.genres.isEmpty {
            DetailsSections {
              HeadlineText("Genres", isBold: true)
              HStack {
                ForEach(show.genres, id: \.self) { genre in
                  BodyText(genre)
                }
              }
            }
            .padding(.bottom)
          }
          
          DetailsSections {
            HeadlineText("Schedule", isBold: true)
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 12) {
                ForEach(show.schedule.days, id: \.self) { day in
                  BodyText(day)
                }
              }
            }
            .padding(.bottom)
            
            if !show.schedule.time.isEmpty {
              DetailsSections {
                BodyText("Exhibition time", isBold: true)
                BodyText(show.schedule.time)
              }
              .padding(.bottom)
              
            }
          }
          
          DetailsSections {
            BodyText("Status", isBold: true)
            BodyText(show.status)
          }
          .padding(.bottom)
          
          if let rating = show.rating.average {
            DetailsSections {
              BodyText("Rating", isBold: true)
              BodyText("\(rating)")
            }
            .padding(.bottom)
          }
          
          Button("Episodes") {
            let showId = "\(store.state.show.id)"
            store.send(.presentEpisodesDetails(showId: showId))
          }
          .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
      }
    }
    .ignoresSafeArea(edges: .top)
    .sheet(item: $store.scope(state: \.destination?.showDetails, action: \.destination.showDetails)) { store in
      EpisodesView(store: store)
    }
  }
}

private struct DetailsSections<Content: View>: View {
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: Tokens.Spacing.small.rawValue) {
      content
    }
  }
}

#Preview {
  ShowDetailsView(
    store: Store(
      initialState: ShowDetailsStore.State(
        phase: .ready,
        show: ShowResponse(
          id: 123,
          url: "",
          name: "Movie title mock",
          status: "In exhibition",
          genres: ["Genre test, Genre test 2"],
          summary: "Summary of the movie as a mock",
          image: .init(
            medium: "https://static.tvmaze.com/uploads/images/medium_portrait/610/1525272.jpg",
            original: "https://static.tvmaze.com/uploads/images/original_untouched/610/1525272.jpg"
          ),
          schedule: ShowScheduleResponse(
            time: "Once per week",
            days: ["Monday", "Sunday"]
          ),
          rating: ShowRatingResponse(average: 4.5)
        )
      ),
      reducer: {
        ShowDetailsStore()
      }
    ))
}
