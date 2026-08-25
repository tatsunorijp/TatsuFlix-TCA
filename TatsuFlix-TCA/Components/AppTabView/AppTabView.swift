//
//  MainTabBarRouter.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-25.
//

import SwiftUI
import Observation

@Observable
class Router {
  var home: [HomeRouterPaths] = []
  var search: [SearchRouterPaths] = []
  var favorites: [FavoritesRouterPaths] = []
  var settings: [SettingsRouterPaths] = []
}

enum AppScreen: Hashable, Identifiable, CaseIterable {
  case home
  case search
  case favorites
  case settings
  
  var id: AppScreen { self }
}

extension AppScreen {
  var label: some View {
    switch self {
    case .home:
      Label("Home", systemImage: "house")
    case .search:
      Label("Search", systemImage: "magnifyingglass")
    case .favorites:
      Label("Favorites", systemImage: "star")
    case .settings:
      Label("Settings", systemImage: "gearshape")
    }
  }
  
  @ViewBuilder
  var destination: some View {
    switch self {
    case .home:
      HomeNavigationStack()
    case .search:
      SearchNavigationStack()
    case .favorites:
      FavoritesNavigationStack()
    case .settings:
      SettingsNavigationStack()
    }
  }
}

struct AppTabView: View {
  @Binding var selection: AppScreen?
  
  var body: some View {
    TabView(selection: $selection) {
      ForEach(AppScreen.allCases) { screen in
        Tab(value: screen) {
          screen.destination
        } label: {
          screen.label
        }
      }
    }
  }
}

// Preview Test
struct AppTabViewPreview: View {
  @State private var selection: AppScreen? = .home
  
  var body: some View {
    AppTabView(selection: $selection)
      .environment(Router())
  }
}

#Preview {
  AppTabViewPreview()
}
