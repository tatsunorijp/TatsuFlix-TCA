//
//  TatsuFlix_MVIApp.swift
//  TatsuFlix-MVI
//
//  Created by Wellington Tatsunori Asahide on 2026-07-25.
//

import SwiftUI
import SwiftData

@main
struct TatsuFlix_MVIApp: App {
//  var sharedModelContainer: ModelContainer = {
//    let schema = Schema([
//      Item.self,
//    ])
//    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//    
//    do {
//      return try ModelContainer(for: schema, configurations: [modelConfiguration])
//    } catch {
//      fatalError("Could not create ModelContainer: \(error)")
//    }
//  }()
//
  @State private var router = Router()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(router)
    }
//    .modelContainer(sharedModelContainer)
  }
}
