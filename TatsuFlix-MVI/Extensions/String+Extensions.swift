//
//  String+Extensions.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-27.
//

import Foundation
import UIKit

extension String {
  func removeHTMLTags() -> String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
  }
}
