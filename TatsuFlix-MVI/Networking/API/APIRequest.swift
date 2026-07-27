//
//  APIRequest.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation

protocol APIRequest {
  associatedtype Response: Codable
  var endpoint: Endpoint { get }
}

extension APIRequest {
  var url: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = BaseURL.getBaseURL()
    components.path = endpoint.path
    components.queryItems = endpoint.queryItem.map { name, value in
      URLQueryItem(name: name, value: value)
    }
    return components.url
  }
}
