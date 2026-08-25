//
//  LoadingView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import SwiftUI

struct LoadingView: View {
  var body: some View {
    VStack(spacing: 20) {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
        .scaleEffect(1.5)
      
      Text("Loading...")
        .font(.headline)
        .foregroundColor(.secondary)
    }
    .padding(30)
    .background(Color(.systemBackground))
    .cornerRadius(15)
    .shadow(radius: 10)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  LoadingView()
}
