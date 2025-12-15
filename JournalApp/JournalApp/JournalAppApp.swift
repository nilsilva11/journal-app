//
//  JournalAppApp.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI
import SwiftData

@main
struct JournalAppApp: App {

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Goal.self, DailyEntry.self, Habit.self])
    }
}
