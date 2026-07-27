//
//  ContentView.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//  @Environment(\.modelContext) private var modelContext
//  @Query private var items: [Item]
  
  @State private var selectedAppTab: AppScreen? = .home
  
  var body: some View {
    AppTabView(selection: $selectedAppTab)
  }
}

#Preview {
  ContentView()
    .environment(Router())
//    .modelContainer(for: Item.self, inMemory: true)
}
