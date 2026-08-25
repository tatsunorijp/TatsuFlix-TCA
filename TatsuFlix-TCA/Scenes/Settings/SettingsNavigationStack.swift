//
//  SettingsNavigationStack.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-26.
//

import Foundation
import SwiftUI

enum SettingsRouterPaths: Hashable {
  case settings
}

struct SettingsNavigationStack: View {
  @Environment(Router.self) private var router
  
  var body: some View {
    @Bindable var router = router
    
    NavigationStack(path: $router.settings) {
      Text("Settings")
        .navigationDestination(for: SettingsRouterPaths.self) { route in
          switch route {
          case .settings:
            Text("Settings screen")
          }
        }
    }
  }
}

// Preview Test
struct SettingsNavigationStackPreview: View {
  var body: some View {
    SettingsNavigationStack()
      .environment(Router())
  }
}

#Preview {
  SettingsNavigationStackPreview()
}

