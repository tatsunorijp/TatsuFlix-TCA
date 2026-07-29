//
//  Endpoint.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation

enum Endpoint {
  case shows(page: Int)
  case episodes(showId: String)
  case search(query: String)
  
  var path: String {
    switch self {
    case .shows: "/shows"
    case let .episodes(showId): "/shows/\(showId)/episodes"
    case .search: "/search/shows"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .shows,
        .episodes,
        .search:
        .get
    }
  }
  
  var queryItem: [String: String] {
    switch self {
    case let .shows(page):
      ["page": "\(page)"]

    case let .search(query):
      ["q": query]

    default:
      [:]
    }
  }
}
