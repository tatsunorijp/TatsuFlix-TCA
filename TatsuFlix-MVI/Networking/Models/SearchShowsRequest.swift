//
//  SearchShowsRequest.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-29.
//

import Foundation

struct SearchShowsRequest: APIRequest {
  typealias Response = [SearchSeriesResponse]
  let query: String
  var endpoint: Endpoint {
    .search(query: query)
  }
}

struct SearchSeriesResponse: Codable, Equatable {
  let score: Double
  let show: ShowResponse
}
