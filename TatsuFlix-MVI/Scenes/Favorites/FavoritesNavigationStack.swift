//
//  FavoritesNavigationStack.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation
import SwiftUI

enum FavoritesRouterPaths: Hashable {
  case favorites
}

struct FavoritesNavigationStack: View {
  @Environment(Router.self) private var router
  
  var body: some View {
    @Bindable var router = router
    
    NavigationStack(path: $router.favorites) {
      Text("Favorites")
        .navigationDestination(for: FavoritesRouterPaths.self) { route in
          switch route {
          case .favorites:
            Text("Favorites screen")
          }
        }
    }
  }
}

// Preview Test
struct FavoritesNavigationStackPreview: View {
  var body: some View {
    FavoritesNavigationStack()
      .environment(Router())
  }
}

#Preview {
  FavoritesNavigationStackPreview()
}

