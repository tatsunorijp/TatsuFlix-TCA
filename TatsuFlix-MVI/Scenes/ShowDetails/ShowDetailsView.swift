//
//  ShowDetailsView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import SwiftUI
import ComposableArchitecture

struct ShowDetailsView: View {
  let store: StoreOf<ShowDetailsStore>
  
    var body: some View {
      let show = store.show
      VStack {
        Text(show.name)
        Text(show.summary ?? "")
        HStack {
          ForEach(show.genres, id: \.self) {
            Text($0)
          }
        }
        HStack {
          ForEach(show.schedule.days, id: \.self) {
            Text($0)
          }
        }
        Button("Episodes") {
          
        }
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
          image: nil,
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
