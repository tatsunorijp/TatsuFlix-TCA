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
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack(spacing: Tokens.Spacing.medium.rawValue) {
        SearchTextField(
          searchText: Binding(
            get: { store.searchText },
            set: { store.send(.search($0)) }
          )
        )
        .padding(.horizontal)
        searchContent
      }
      .padding(.top)
      .navigationTitle("Search")
    } destination: { store in
      switch store.case {
      case let .showDetails(store):
        ShowDetailsView(store: store)
      }
    }
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
            .onTapGesture {
              store.send(.showDetails(for: show))
            }
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
}

private struct SearchTextField: View {
  @Binding var searchText: String

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
