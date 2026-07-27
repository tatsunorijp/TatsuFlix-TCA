//
//  EpisodeRequest.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation

struct EpisodesRequest: APIRequest {
  typealias Response = [EpisodeResponse]
  let showId: String
  var endpoint: Endpoint {
    .episodes(showId: showId)
  }
}
