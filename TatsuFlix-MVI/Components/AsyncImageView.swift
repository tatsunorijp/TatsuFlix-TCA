//
//  AsyncImageView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-27.
//

import SwiftUI

struct AsyncImageView: View {
  let urlString: String?
//  var width: CGFloat = 200
//  var height: CGFloat = 200

  var body: some View {
    AsyncImage(url: URL(string: urlString ?? "")) { phase in
      switch phase {
      case .empty:
        ProgressView()
      case let .success(image):
        image
          .resizable()
          .scaledToFit()
      case .failure:
        Image(systemName: "photo.badge.exclamationmark")
      @unknown default:
        EmptyView()
      }
    }
//    .frame(width: width, height: height)
  }
}

#Preview {
  AsyncImageView(urlString: nil)
}
