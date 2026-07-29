//
//  SearchView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-29.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
  private enum Constants {
    static let searchStateIconSize: CGFloat = Tokens.Size.xLarge.rawValue * 1.5
  }
  @Bindable var store: StoreOf<SearchStore>

  private let columns: [GridItem] = Array(
    repeating: .init(.flexible()), count: 2
  )
  
  var body: some View {
    VStack(spacing: Tokens.Spacing.medium.rawValue) {
      SearchTextField(
        debouncedText: Binding (
          get: { store.searchText },
          set: { handleDebouncedSearch($0) }
        ))
      .padding(.horizontal)
      searchContent
    }
    .padding(.top)
    .navigationTitle("Search")
  }
  
  @ViewBuilder
  private var searchContent: some View {
    switch store.phase {
    case .ready:
      EmptySearchView(
        headline: "Search Shows",
        bodyText: "Type a show name to find something to watch."
      )
    case .loading:
      LoadingView()
    case .showingSearchResult:
      resultsView
    case .failed:
      ErrorView
    case .searchResultEmpty:
      EmptySearchView(
        headline: "No Result Found",
        bodyText: "No results found. Please try again."
      )
    }
  }
  
  private var resultsView: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(store.showsSearchResult, id: \.id) { show in
          ShowCardView(show: show)
        }
      }
      .padding(.top)
    }
  }

  @ViewBuilder
  private func EmptySearchView(
    headline: String,
    bodyText: String
  ) -> some View {
    SearchStateView(
      symbolName: "magnifyingglass",
      color: .blue,
      iconSize: Constants.searchStateIconSize,
      iconRotation: -20,
      headline: headline,
      bodyText: bodyText
    )
  }
  
  @ViewBuilder
  private var ErrorView: some View {
    SearchStateView(
      symbolName: "exclamationmark.triangle",
      color: .red,
      iconSize: Constants.searchStateIconSize,
      headline: "Something went wrong"
    )
  }
  
  private func handleDebouncedSearch(_ text: String) {
    let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
    store.send(.search(query))
  }
}

private struct SearchTextField: View {
  @Binding var debouncedText: String
  @State var searchText: String = ""

  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.gray)
      
      TextField("Search...", text: $searchText)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
      
      if !searchText.isEmpty {
        Button {
          searchText = ""
        } label: {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
        }
      }
    }
    .padding(Tokens.Spacing.medium.rawValue)
    .background(Color(.systemGray6))
    .cornerRadius(10)
    // UI Logic
    .task(id: searchText) {
      do {
        if searchText.isEmpty {
          debouncedText = searchText
        } else {
          try await Task.sleep(for: .seconds(1))
          debouncedText = searchText
        }
      } catch {
        // Task was cancelled because user typed a new character
      }
    }
  }
}

#Preview {
  NavigationStack {
    SearchView(
      store: Store(initialState: SearchStore.State(
        searchText: "",
        showsSearchResult: []
      )) {
        SearchStore(service: NetworkClient())
      }
    )
  }
}
