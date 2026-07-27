//
//  EpisodeResponse.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation

struct EpisodeResponse: Codable, Identifiable, Equatable {
  let id: Int
  let name: String
  let number: Int
  let season: Int
  let summary: String?
  let image: EpisodeImage?
}

struct EpisodeImage: Codable, Equatable {
  let medium: String
  let original: String
}
