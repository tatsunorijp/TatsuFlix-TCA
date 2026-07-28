//
//  TextComponents.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-27.
//

import SwiftUI

struct TitleText: View {
  let text: String
  let isBold: Bool
  
  init(_ text: String, isBold: Bool = false) {
    self.text = text
    self.isBold = isBold
  }
  
  var body: some View {
    Text(text)
      .font(.title)
      .fontWeight(isBold ? .bold : .regular)
  }
}

struct HeadlineText: View {
  let text: String
  let isBold: Bool
  
  init(_ text: String, isBold: Bool = false) {
    self.text = text
    self.isBold = isBold
  }
  
  var body: some View {
    Text(text)
      .font(.headline)
      .fontWeight(isBold ? .bold : .regular)
  }
}

struct BodyText: View {
  let text: String
  let isBold: Bool
  
  init(_ text: String, isBold: Bool = false) {
    self.text = text
    self.isBold = isBold
  }
  
  var body: some View {
    Text(text)
      .font(.body)
      .fontWeight(isBold ? .bold : .regular)
  }
}

struct FootnoteText: View {
  let text: String
  let isBold: Bool
  
  init(_ text: String, isBold: Bool = false) {
    self.text = text
    self.isBold = isBold
  }
  
  var body: some View {
    Text(text)
      .font(.footnote)
      .fontWeight(isBold ? .bold : .regular)
  }
}
