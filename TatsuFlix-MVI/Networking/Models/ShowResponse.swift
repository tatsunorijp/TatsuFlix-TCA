//
//  ShowResponse.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation

struct ShowResponse: Codable, Identifiable, Equatable {
    let id: Int
    let url: String
    let name: String
    let status: String
    let genres: [String]
    let summary: String?
    let image: ShowImageResponse?
    let schedule: ShowScheduleResponse
    let rating: ShowRatingResponse
}

struct ShowImageResponse: Codable, Equatable {
    let medium: String
    let original: String
}

struct ShowRatingResponse: Codable, Equatable {
    let average: Double?
}

struct ShowScheduleResponse: Codable, Equatable {
    let time: String
    let days: [String]
}
