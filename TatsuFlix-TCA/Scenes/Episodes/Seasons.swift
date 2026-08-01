//
//  Seasons.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-27.
//

import Foundation

struct ShowSeason: Identifiable, Equatable {
  let id: Int
  let seasonNumber: Int
  let episodes: [EpisodeResponse]
}
