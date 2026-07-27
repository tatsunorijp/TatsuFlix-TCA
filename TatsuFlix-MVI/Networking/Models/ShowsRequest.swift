//
//  ShowsRequest.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation

struct GetShowsRequest: APIRequest {
  typealias Response = [ShowResponse]
  let page: Int
  var endpoint: Endpoint {
    .shows(page: page)
  }
  
//  let endpoint: Endpoint
//  
//  init(page: Int, endpoint: Endpoint) {
//    self.endpoint = .shows(page: page)
//  }
}
