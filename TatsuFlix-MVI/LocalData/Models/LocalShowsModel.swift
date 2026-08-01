//
//  LocalShowsModel.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-08-01.
//

import Foundation
import SwiftData

@Model
final class LocalShowsModel {
  @Attribute(.unique) var id: Int
  var url: String
  var name: String
  var status: String
  var genres: [String]
  var summary: String?
  var image: LocalShowImage?
  var schedule: LocalShowSchedule
  var rating: LocalShowRating

  init(shows: ShowResponse) {
    id = shows.id
    url = shows.url
    name = shows.name
    status = shows.status
    genres = shows.genres
    summary = shows.summary
    image = shows.image.map {
      LocalShowImage(
        medium: $0.medium,
        original: $0.original
      )
    }
    schedule = LocalShowSchedule(
      time: shows.schedule.time,
      days: shows.schedule.days
    )
    rating = LocalShowRating(average: shows.rating.average)
  }

  func convertToShowResponse() -> ShowResponse {
    return ShowResponse(
      id: id,
      url: url,
      name: name,
      status: status,
      genres: genres,
      summary: summary,
      image: image?.convertToShowImageResponse(),
      schedule: schedule.convertToShowScheduleResponse(),
      rating: rating.convertToShowRatingResponse()
    )
  }
}

struct LocalShowImage: Codable, Equatable {
  let medium: String
  let original: String

  init(medium: String, original: String) {
    self.medium = medium
    self.original = original
  }

  func convertToShowImageResponse() -> ShowImageResponse {
    ShowImageResponse(
      medium: medium,
      original: original
    )
  }
}

struct LocalShowSchedule: Codable, Equatable {
  let time: String
  let days: [String]

  init(time: String, days: [String]) {
    self.time = time
    self.days = days
  }

  func convertToShowScheduleResponse() -> ShowScheduleResponse {
    ShowScheduleResponse(
      time: time,
      days: days
    )
  }
}

struct LocalShowRating: Codable, Equatable {
  let average: Double?

  init(average: Double?) {
    self.average = average
  }

  func convertToShowRatingResponse() -> ShowRatingResponse {
    ShowRatingResponse(average: average)
  }
}
