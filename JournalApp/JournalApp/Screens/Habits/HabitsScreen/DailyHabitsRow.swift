//
//  DailyHabitsRow.swift
//  JournalApp
//
//  Created by Nil Silva on 17/12/2025.
//

import SwiftUI
import SwiftData

struct DailyHabitsRow: View {
    @Query var habits: [Habit]
    
    
    var todaysHabits: [Habit] {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return habits.filter { $0.frequency.contains(weekday) }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if todaysHabits.isEmpty {
                Text("No habits scheduled for today 💤")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(todaysHabits) { habit in
                            HabitRingView(habit: habit)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
            }
        }
    }
}


struct HabitRingView: View {
    let habit: Habit
    
    var isCompleted: Bool {
        habit.isCompleted(on: Date())
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                habit.toggleCompletion(on: Date())
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    
                    Circle()
                        .stroke(Color(hex: habit.colorHex).opacity(0.15), lineWidth: 6)
                        .frame(width: 60, height: 60)
                    
                    
                    Circle()
                        .trim(from: 0, to: isCompleted ? 1 : 0)
                        .stroke(
                            Color(hex: habit.colorHex),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    
                    Text(habit.icon)
                        .font(.title2)
                        .opacity(isCompleted ? 1 : 0.7)
                        .scaleEffect(isCompleted ? 1.1 : 1.0)
                }
                
                Text(habit.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .frame(width: 70)
                    .foregroundStyle(isCompleted ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        
        let weekday = Calendar.current.component(.weekday, from: Date())
        
        let h1 = Habit(title: "Meditate", icon: "🧘‍♀️", colorHex: "#8E44AD", frequency: [weekday], startDate: Date())
        let h2 = Habit(title: "Water", icon: "💧", colorHex: "#3498DB", frequency: [weekday], startDate: Date())
        let h3 = Habit(title: "Water", icon: "💧", colorHex: "#3498DB", frequency: [weekday], startDate: Date())
        let h4 = Habit(title: "Water", icon: "💧", colorHex: "#3498DB", frequency: [weekday], startDate: Date())
        let h5 = Habit(title: "Water", icon: "💧", colorHex: "#3498DB", frequency: [weekday], startDate: Date())
        let h6 = Habit(title: "Water", icon: "💧", colorHex: "#3498DB", frequency: [weekday], startDate: Date())
        container.mainContext.insert(h1)
        container.mainContext.insert(h2)
        container.mainContext.insert(h3)
        container.mainContext.insert(h4)
        container.mainContext.insert(h5)
        container.mainContext.insert(h6)
        
        return DailyHabitsRow()
            .modelContainer(container)
    } catch {
        return Text("Error")
    }
}
