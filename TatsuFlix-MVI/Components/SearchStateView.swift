//
//  SearchStateView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-29.
//

import SwiftUI

struct SearchStateView: View {
  let symbolName: String
  let color: Color
  let iconSize: CGFloat
  var iconRotation: Double = 0
  let headline: String
  var bodyText: String? = nil
  
  var body: some View {
    Spacer()
    VStack(spacing: Tokens.Spacing.medium.rawValue) {
      SearchStateIllustration(
        symbolName: symbolName,
        color: color,
        iconSize: iconSize,
        iconRotation: iconRotation
      )
      
      VStack(spacing: Tokens.Spacing.small.rawValue) {
        TitleText(headline, isBold: true)
        
        if let bodyText {
          BodyText(bodyText)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, Tokens.Spacing.medium.rawValue)
    Spacer()
  }
}

// Lot of in-place numbers, but it's ok, it's a personal project, AI Generated and is a custom icon style
private struct SearchStateIllustration: View {
  let symbolName: String
  let color: Color
  let iconSize: CGFloat
  let iconRotation: Double
  
  var body: some View {
    ZStack {
      Circle()
        .fill(color.opacity(0.08))
        .frame(width: 160, height: 160)
      
      Image(systemName: symbolName)
        .font(.system(size: iconSize, weight: .light))
        .foregroundStyle(color.opacity(0.35))
        .rotationEffect(.degrees(iconRotation))
      
      Image(systemName: "sparkle")
        .font(.title3)
        .foregroundStyle(color.opacity(0.35))
        .offset(x: -68, y: -48)
      
      Image(systemName: "sparkle")
        .font(.caption)
        .foregroundStyle(color.opacity(0.25))
        .offset(x: 72, y: -26)
      
      Circle()
        .fill(color.opacity(0.08))
        .frame(width: 24, height: 24)
        .offset(x: 78, y: 54)
      
      Circle()
        .fill(color.opacity(0.08))
        .frame(width: 16, height: 16)
        .offset(x: -78, y: 44)
    }
  }
}

#Preview {
  SearchStateView(
    symbolName: "magnifyingglass",
    color: .blue,
    iconSize: Tokens.Size.xxLarge.rawValue,
    iconRotation: -20,
    headline: "Search Shows",
    bodyText: "Type a show name to find something to watch."
  )
}
