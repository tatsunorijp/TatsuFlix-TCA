//
//  LocalShowsModelTests.swift
//  TatsuFlix-MVITests
//
//  Created by Wellington Tatsunori Asahide on 2026-08-01.
//

import Testing
@testable import TatsuFlix_TCA

struct LocalShowsModelTests {
  @Test func testInitFromShowResponse() {
    let show = makeShowResponseMock()

    let localShow = LocalShowsModel(shows: show)

    #expect(localShow.id == show.id)
    #expect(localShow.url == show.url)
    #expect(localShow.name == show.name)
    #expect(localShow.status == show.status)
    #expect(localShow.genres == show.genres)
    #expect(localShow.summary == show.summary)
    #expect(localShow.image == LocalShowImage(
      medium: show.image?.medium ?? "",
      original: show.image?.original ?? ""
    ))
    #expect(localShow.schedule == LocalShowSchedule(
      time: show.schedule.time,
      days: show.schedule.days
    ))
    #expect(localShow.rating == LocalShowRating(average: show.rating.average))
  }

  @Test func testConvertToShowResponse() {
    let show = makeShowResponseMock()
    let localShow = LocalShowsModel(shows: show)

    let convertedShow = localShow.convertToShowResponse()

    #expect(convertedShow == show)
  }

  @Test func testNilImageSummaryAndRating() {
    let show = makeShowResponseMock(
      summary: nil,
      image: nil,
      rating: ShowRatingResponse(average: nil)
    )

    let localShow = LocalShowsModel(shows: show)
    let convertedShow = localShow.convertToShowResponse()

    #expect(localShow.summary == nil)
    #expect(localShow.image == nil)
    #expect(localShow.rating == LocalShowRating(average: nil))
    #expect(convertedShow == show)
  }

  @Test func testConvertToShowImageResponse() {
    let localImage = LocalShowImage(
      medium: "https://example.com/medium.jpg",
      original: "https://example.com/original.jpg"
    )

    let response = localImage.convertToShowImageResponse()

    #expect(response == ShowImageResponse(
      medium: localImage.medium,
      original: localImage.original
    ))
  }

  @Test func testConvertToShowScheduleResponse() {
    let localSchedule = LocalShowSchedule(
      time: "21:00",
      days: ["Monday", "Friday"]
    )

    let response = localSchedule.convertToShowScheduleResponse()

    #expect(response == ShowScheduleResponse(
      time: localSchedule.time,
      days: localSchedule.days
    ))
  }

  @Test func testConvertToShowRatingResponse() {
    let localRating = LocalShowRating(average: 8.4)

    let response = localRating.convertToShowRatingResponse()

    #expect(response == ShowRatingResponse(average: localRating.average))
  }

  private func makeShowResponseMock(
    summary: String? = "<p>A mock show summary.</p>",
    image: ShowImageResponse? = ShowImageResponse(
      medium: "https://example.com/medium.jpg",
      original: "https://example.com/original.jpg"
    ),
    rating: ShowRatingResponse = ShowRatingResponse(average: 8.4)
  ) -> ShowResponse {
    ShowResponse(
      id: 1,
      url: "https://example.com/shows/1",
      name: "Mock Show",
      status: "Running",
      genres: ["Drama", "Action"],
      summary: summary,
      image: image,
      schedule: ShowScheduleResponse(
        time: "21:00",
        days: ["Monday", "Friday"]
      ),
      rating: rating
    )
  }
}
