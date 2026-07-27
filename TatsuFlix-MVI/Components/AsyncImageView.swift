//
//  AsyncImageView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-27.
//

import SwiftUI

struct AsyncImageView: View {
  let urlString: String?
  var width: CGFloat?
  var height: CGFloat?
  var contentMode: ContentMode
  
  init(
    urlString: String?,
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    contentMode: ContentMode = .fit
  ) {
    self.urlString = urlString
    self.width = width
    self.height = height
    self.contentMode = contentMode
  }

  var body: some View {
    AsyncImage(url: URL(string: urlString ?? "")) { phase in
      switch phase {
      case .empty:
        ProgressView()
      case let .success(image):
        image
          .resizable()
          .aspectRatio(contentMode: contentMode)
      case .failure:
        Image(systemName: "photo.badge.exclamationmark")
      @unknown default:
        EmptyView()
      }
    }
    .frame(width: width, height: height)
  }
}

#Preview {
  AsyncImageView(urlString: nil)
}
