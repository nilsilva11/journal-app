//
//  ContentView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI

struct ContentView: View {
    
    //to define what is the tab that opens by default
    @State private var selectedTab: Int = 1
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            TabView(selection: $selectedTab) {
                

                // --- TAB 1: HABITS ---
                Text("Ecrã de Hábitos (Habits)")
                    .toolbar(.hidden, for: .tabBar)
               
                .tag(0)

                // --- TAB 2: HOME  ---
                HomeView()
                    .toolbar(.hidden, for: .tabBar)
                .tag(1) //main tab
                
                // --- TAB 3: GOALS ---
                Text("Ecrã de Objetivos (Goals)")
                    .toolbar(.hidden, for: .tabBar)
                .tag(2)
            }
            .ignoresSafeArea(.keyboard)
            CustomTabView(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
}
