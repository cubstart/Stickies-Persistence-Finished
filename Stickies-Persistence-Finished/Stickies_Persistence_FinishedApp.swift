//
//  Stickies_Persistence_FinishedApp.swift
//  Stickies-Persistence-Finished
//
//  Created by Justin Wong on 4/3/25.
//

import SwiftData
import SwiftUI

@main
struct Stickies_Persistence_FinishedApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Stickie.self])
        }
    }
}
