//
//  HabitsView.swift
//  JournalApp
//
//  Created by Nil Silva on 15/12/2025.
//

import SwiftUI
import SwiftData

struct TrackerView: View {
    
    @Query(sort: \Habit.createdAt, order: .reverse) var habits: [Habit]
    @State private var showAddSheet: Bool = false
    
    var body: some View {
        
        ZStack {
            
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            
            VStack (alignment: .leading, spacing: 15) {
                
                MainHeaderView( name: "Sofia")
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        
                        VStack (alignment: .leading, spacing: -10){
                            Text("Habits")
                            Text("Tracker")
                                .foregroundColor(Color("AppAccent"))
                        }
                        .font(.system(size: 48)).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        if habits.isEmpty {
                
                            VStack(spacing: 10) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.secondary)
                                    .padding(.bottom, 5)
                                Text("No habits yet")
                                    .font(.headline)
                                Text("Tap + to start your journey")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                            
                            
                        } else {
                            
                            LazyVStack(spacing: 20) {
                                ForEach(habits) { habit in
                                    HabitHeatmapCard(habit: habit)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 100)
                            
                        }
                    }
                }
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    Button(action: {
                        showAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color("AppAccent"))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                    
                }
                .contentMargins(.bottom, 70, for: .scrollContent)
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddHabitView()
        }
    }
}

#Preview {
    TrackerView()
        .modelContainer(for: Habit.self, inMemory: true)
}
