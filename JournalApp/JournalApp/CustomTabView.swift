//
//  CustomTabView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI
import SwiftData

enum Tab: String, CaseIterable {
    case habits = "list"
    case home = "Home"
    case goals = "goal"
}

struct CustomTabView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedTab: Tab = .home

    @State private var showHabitSheet = false
    @State private var showEntrySheet = false
    @State private var showGoalSheet = false
    
    var body: some View {
        ZStack {
            
            Group {
                switch selectedTab {
                case .habits:
                    TrackerView()
                case .home:
                    HomeView()
                case .goals:
                    GoalsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom, spacing: 110) {
                    
                    FloatingTabBarView(selectedTab: $selectedTab)
                    
                    Button(action: {
                        handleFabTap()
                    }) {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color("AppAccent"))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 25)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        
        .sheet(isPresented: $showHabitSheet) {
            AddHabitView(habitToEdit: nil)
        }
        .sheet(isPresented: $showEntrySheet) {
            WriteEntryView(
                entryToEdit: nil,
                date: Date(),     
                onSave: { title, text in
                    let newEntry = DailyEntry(
                        date: Date(),
                        title: title,
                        text: text
                    )
                    modelContext.insert(newEntry)
                    try? modelContext.save()
                    showEntrySheet = false
                }
            )
        }
        .sheet(isPresented: $showGoalSheet) {
            AddGoalView(
                    goalToEdit: nil,
                    onSave: { text, subtext in
                        
                        let newGoal = Goal(
                            text: text,
                            subtext: subtext,
                            isCompleted: false
                        )
                        
                        modelContext.insert(newGoal)
                        showGoalSheet = false
                    }
                )
                .presentationDetents([.height(400)])
        }
    }
    
    func handleFabTap() {
        switch selectedTab {
        case .habits:
            showHabitSheet = true
        case .home:
            showEntrySheet = true
        case .goals:
            showGoalSheet = true
        }
    }
    
}

#Preview {
    CustomTabView()
}

