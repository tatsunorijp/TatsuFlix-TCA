//
//  ShowCardView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-29.
//

import SwiftUI

struct ShowCardView: View {
  let show: ShowResponse
  
  var body: some View {
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
    .padding(.top, Tokens.Spacing.medium.rawValue)
  }
}

#Preview {
  ShowCardView(
    show: ShowResponse(
      id: 1,
      url: "",
      name: "Preview Show",
      status: "Running",
      genres: ["Drama"],
      summary: nil,
      image: nil,
      schedule: ShowScheduleResponse(time: "", days: []),
      rating: ShowRatingResponse(average: 8.5)
    )
  )
}
