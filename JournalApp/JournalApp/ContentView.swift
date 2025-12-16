//
//  ContentView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    //to define what is the tab that opens by default
    @State private var selectedTab: Int = 1
    var body: some View {
        
        CustomTabView(selectedTab: $selectedTab)
        
    }
}


#Preview {
    ContentView()
        .modelContainer(for: [Goal.self, DailyEntry.self, Habit.self], inMemory: true)
}



