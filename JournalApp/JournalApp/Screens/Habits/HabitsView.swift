//
//  HabitsView.swift
//  JournalApp
//
//  Created by Nil Silva on 15/12/2025.
//

import SwiftUI
import SwiftData

struct TrackerView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var selectedViewType: String = "Weekly"
    let viewTypes = ["Weekly", "Expanded"]
    
    @Query(sort: \Habit.createdAt, order: .reverse) var habits: [Habit]
    @State private var showAddSheet: Bool = false
    
    @State private var habitToEdit: Habit?
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                
                VStack (alignment: .leading, spacing: 0) {
                    
                    VStack{
                        MainHeaderView( name: "Sofia")
                    }
                    .background(Color.white.ignoresSafeArea(edges: .top))
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                    .zIndex(1)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            /*VStack (alignment: .leading, spacing: -10){
                                Text("Habits")
                                Text("Tracker")
                                    .foregroundColor(Color("AppAccent"))
                            }
                            .font(.system(size: 48)).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)*/
                            
                            if !habits.isEmpty {
                                
                                HStack(alignment: .center, spacing: 5) {
                                    
                                    Text("Daily Habits")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal)
                                .padding(.top, 20)
                                
                                DailyHabitsRow()
                                
                                Picker("View Type", selection: $selectedViewType) {
                                    ForEach(viewTypes, id: \.self) { type in
                                        Text(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                            }
                            
                            if habits.isEmpty {
                                
                                VStack(spacing: 5) {
                                    Image("Journal")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 250)
                                    Text("No habits yet")
                                        .font(.headline)
                                    Text("Tap + to start your journey")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 120)
                                
                                
                            } else {
                                
                                LazyVStack(spacing: 20) {
                                    ForEach(habits) { habit in
                                        NavigationLink(destination: HabitDetailView(habit: habit)) {
                                            
                                            if selectedViewType == "Expanded" {
                                                
                                                HabitHeatmapCard(
                                                    habit: habit,
                                                    onEdit: { habitToEdit = habit; showAddSheet = true },
                                                    onDelete: { withAnimation { modelContext.delete(habit) } }
                                                )
                                            } else {
                                                
                                                HabitWeeklyCard(
                                                    habit: habit,
                                                    onEdit: { habitToEdit = habit; showAddSheet = true },
                                                    onDelete: { withAnimation { modelContext.delete(habit) } }
                                                )
                                            }
                                            
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 100)
                                
                            }
                        }
                    }
                    .safeAreaInset(edge: .bottom, alignment: .trailing) {
                        Button(action: {
                            habitToEdit = nil
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
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showAddSheet) {
            AddHabitView(habitToEdit: habitToEdit)
        }
    }
}

#Preview {
    TrackerView()
        .modelContainer(for: Habit.self, inMemory: true)
}
