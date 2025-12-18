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
    @State private var vm = TrackerViewModel()
    @Query(sort: \Habit.createdAt, order: .reverse) var habits: [Habit]
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                ZStack(alignment: .top) {
                    
                    
                    MainHeaderView(name: "Sofia")
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                        .zIndex(1)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            if !habits.isEmpty {
                                HStack(alignment: .center, spacing: 5) {
                                    Text("Daily Habits")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal)
                                .padding(.top, 70)
                                
                                DailyHabitsRow()
                                
                                Picker("View Type", selection: $vm.selectedViewType) {
                                    ForEach(vm.viewTypes, id: \.self) { type in
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
                                .padding(.top, 170)
                                
                            } else {
                                
                                LazyVStack(spacing: 20) {
                                    ForEach(habits) { habit in
                                        NavigationLink(destination: HabitDetailView(habit: habit)) {
                                            
                                            
                                            if vm.selectedViewType == "Expanded" {
                                                HabitHeatmapCard(
                                                    habit: habit,
                                                    onEdit: { vm.startEditing(habit) },
                                                    onDelete: { withAnimation { vm.deleteHabit(habit, context: modelContext) } }
                                                )
                                            } else {
                                                HabitWeeklyCard(
                                                    habit: habit,
                                                    onEdit: { vm.startEditing(habit) },
                                                    onDelete: { withAnimation { vm.deleteHabit(habit, context: modelContext) } }
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
                            vm.startCreating()
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
        
        .sheet(isPresented: $vm.showAddSheet) {
            AddHabitView(habitToEdit: vm.habitToEdit)

                .id(vm.habitToEdit?.id ?? UUID())
                .presentationBackground(.ultraThinMaterial)
        }
    }
}

#Preview {
    TrackerView()
        .modelContainer(for: Habit.self, inMemory: true)
}
