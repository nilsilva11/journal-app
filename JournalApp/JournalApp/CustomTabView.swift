//
//  CustomTabView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI
import UIKit

struct CustomTabView: View {
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
        
        //create config
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        //normal icon color
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.progressCard
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.progressCard]
        
        // 3. Definir a cor para o estado SELECIONADO -> EntryBall
        // Nota: Temos de usar UIColor(named:) porque estamos no contexto do UIKit aqui
        let selectedColor = UIColor(named: "AppAccent") ?? UIColor.systemBlue
        
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]
        
        // 4. Aplicar a configuração à TabBar global
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
    }


    var body: some View {
        
        TabView(selection: $selectedTab) {
            NavigationStack {
                TrackerView()
            }
            .tabItem {
                Image(systemName: "list.bullet.clipboard.fill")
                Text("Habits")
            }
            .tag(0)

            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(1)

            NavigationStack {
                GoalsView()
            }
            .tabItem {
                Image(systemName: "target")
                Text("Goals")
            }
            .tag(2)
        }
        .tint(Color("EntryBall"))
    }
}

#Preview {
    CustomTabView(selectedTab: .constant(1))
}
