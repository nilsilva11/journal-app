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
                    
                    
                    VStack{
                        UniversalHeaderView(
                            showDate: false,
                        )
                    }
                    .zIndex(1)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Spacer().frame(height: 10)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                
                                Text("Sofia")
                                    .font(.system(size: 25, weight: .regular))
                                    .foregroundColor(.secondary)
                                
                                HStack(alignment: .firstTextBaseline) {
                                    Text("Daily Habits")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 55)
                            
                            if !habits.isEmpty {
                                
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
                                        .frame(height: 240)
                                    HStack {
                                        Text("Your Habits List is")
                                            .font(.title2)
                                            .fontWeight(.regular)
                                        
                                        Text("Empty")
                                            .foregroundStyle(Color("AppAccent"))
                                            .font(.title2)
                                            .fontWeight(.bold)
                                    }
                                        
                                    Text("Start tracking your habits!")
                                        .font(.subheadline)
                                        .foregroundStyle(Color(.secondaryLabel))
                                    Button(action: {
                                                vm.showAddSheet = true
                                    }) {
                                        Text("Create Habit")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                            .frame(width: 200, height: 50)
                                            .background(Color("AppAccent"))
                                            .clipShape(Capsule())
                                            .shadow(color: Color("AppAccent").opacity(0.4), radius: 10, x: 0, y: 5)
                                    }
                                            .padding(.top, 10)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 65)
                                
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
