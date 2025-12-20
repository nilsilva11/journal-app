//
//  HabitDetailView.swift
//  JournalApp
//
//  Created by Nil Silva on 16/12/2025.
//

import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @Environment(\.dismiss) var dismiss
    
    @State private var currentMonth: Date = Date()
    @State private var showEditSheet: Bool = false
    
    var body: some View {
        
        ZStack {
            
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(Color(.gray), lineWidth: 1)
                                .fill(.white)
                                .frame(width: 120, height: 120)
                            //.shadow(color: Color(hex: habit.colorHex).opacity(0.3), radius: 10, x: 0, y: 0)
                            
                            Image(systemName: habit.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60) 
                                .foregroundColor(Color(hex: habit.colorHex))
                        }
                        
                        Text("Started on \(habit.startDate.formatted(date: .long, time: .omitted))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    
                    HabitCalendarView(habit: habit, currentMonth: $currentMonth, color: Color(hex: habit.colorHex))
                    
                    YearlyHeatmapView(habit: habit)
                    
                    HStack(spacing: 15) {
                        
                        //overall
                        StatCard(
                            title: "Total Done",
                            value: "\(habit.completedDates.count)",
                            icon: "checkmark.circle.fill",
                            color: Color(hex: habit.colorHex)
                        )
                        
                        //this month
                        StatCard(
                            title: "This Month",
                            value: "\(getMonthlyCount())",
                            icon: "calendar",
                            color: Color(hex: habit.colorHex)
                        )
                    }
                    .padding(.horizontal)

                    
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(habit.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    showEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            AddHabitView(habitToEdit: habit)
        }
    }

    private func getMonthlyCount() -> Int {
        let calendar = Calendar.current
        return habit.completedDates.filter { date in
            calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
        }.count
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        let habit = Habit(title: "Ler Livro", icon: "book.fill", colorHex: "8E44AD", frequency: [1,2], startDate: Date())
        habit.toggleCompletion(on: Date())
        
        return NavigationStack {
            ZStack {
                Color(UIColor.systemGray6).ignoresSafeArea()
                HabitDetailView(habit: habit)
            }
        }
        .modelContainer(container)
    } catch {
        return Text("Error preview")
    }
}

