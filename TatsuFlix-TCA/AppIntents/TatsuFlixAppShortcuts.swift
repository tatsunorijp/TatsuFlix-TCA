//
//  TatsuFlixAppShortcuts.swift
//  TatsuFlix-TCA
//

import AppIntents

struct TatsuFlixAppShortcuts: AppShortcutsProvider {
  @AppShortcutsBuilder
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: SearchMovieIntent(),
      phrases: [
        "Search movies and shows in \(.applicationName)",
        "Find a movie in \(.applicationName)",
        "Search a movie in \(.applicationName)",
        "I wanna search for a movie in \(.applicationName)"
      ],
      shortTitle: "Search Movies and Shows",
      systemImageName: "magnifyingglass"
    )
  }
}
