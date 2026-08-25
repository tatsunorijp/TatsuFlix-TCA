//
//  APIError.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation

enum ApiError: Error {
  case invalidURL
  case decodingError
  case serverError(statusCode: Int)
  case unknown(Error)
  
  // Others possible errors
  //  case notFound
  //  case data
  //  case urlComponents
  //  case generic
}
