//
//  BaseURL.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation

class BaseURL {
  private init() {}
  static func getBaseURL() -> String {
    // create if's to change base url when is in prod/dev/qa/etc
    return "api.tvmaze.com"
  }
}
