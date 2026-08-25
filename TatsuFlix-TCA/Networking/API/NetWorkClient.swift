//
//  NetWorkClient.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation

protocol NetworkClientProtocol {
  func send<T: APIRequest>(_ request: T) async throws -> T.Response
}

final class NetworkClient: NetworkClientProtocol {
  func send<T: APIRequest>(_ request: T) async throws -> T.Response {
    guard let url = request.url else {
      throw ApiError.invalidURL
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.endpoint.method.rawValue
    
    let (data, response): (Data, URLResponse)
    do {
      (data, response) = try await URLSession.shared.data(for: urlRequest)
    } catch {
      throw ApiError.unknown(error)
    }
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw ApiError.unknown(NSError(domain: "Invalid response", code: 0))
    }
    
    guard (200..<300).contains(httpResponse.statusCode) else {
      throw ApiError.serverError(statusCode: httpResponse.statusCode)
    }
    
    do {
      return try JSONDecoder().decode(T.Response.self, from: data)
    } catch {
      throw ApiError.decodingError
    }
  }
}

/// References in https://dev.to/markkazakov/modern-networking-in-ios-with-urlsession-and-asyncawait-a-practical-guide-4o0o
