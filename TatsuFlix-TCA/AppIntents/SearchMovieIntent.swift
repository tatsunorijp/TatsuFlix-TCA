//
//  SearchMovieIntent.swift
//  TatsuFlix-TCA
//

import AppIntents

// TODO: Migrate to `.system.searchInApp` when it is available in the project SDK.
@AppIntent(schema: .system.search)
struct SearchMovieIntent: ShowInAppSearchResultsIntent, TargetContentProvidingIntent {
  static let title: LocalizedStringResource = "Search a Movie"
  static let description = IntentDescription(
    "Searches for a movie or TV show and displays the results in TatsuFlix."
  )
  static let supportedModes: IntentModes = .foreground
  static let searchScopes: [StringSearchScope] = [.movies, .tv]

  @Parameter(title: "Search term")
  var criteria: StringSearchCriteria
}
