//
//  AppIntentHandlingModifier.swift
//  TatsuFlix-TCA
//

import AppIntents
import SwiftUI

struct AppIntentHandlingModifier: ViewModifier {
  @State private var presentedSearch: SearchPresentation?

  func body(content: Content) -> some View {
    content
      .sheet(item: $presentedSearch) { presentation in
        SearchView(store: presentation.store)
          .presentationDragIndicator(.visible)
      }
      .onAppIntentExecution(SearchMovieIntent.self) { intent in
        presentSearch(for: intent.criteria.term)
      }
  }

  private func presentSearch(for searchTerm: String) {
    let query = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !query.isEmpty else { return }

    presentedSearch = SearchPresentation(query: query)
  }
}
