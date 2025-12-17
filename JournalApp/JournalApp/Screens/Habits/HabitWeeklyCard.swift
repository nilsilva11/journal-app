//
//  HabitWeeklyCard.swift
//  JournalApp
//
//  Created by Nil Silva on 16/12/2025.
//

import SwiftUI
import SwiftData

struct HabitWeeklyCard: View {
    let habit: Habit
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    var last7Days: [Date] {
        let calendar = Calendar.current
        return (0..<7).compactMap { index in
            calendar.date(byAdding: .day, value: -((6) - index), to: Date())
        }
    }
    
    let historyWeeks = 52
    @State private var currentWeekIndex: Int = 52
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            HStack {
                ZStack {
                    Circle()
                        .fill(Color(.white).opacity(0.6))
                        .frame(width: 40, height: 40)
                    Text(habit.icon)
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(getDateRangeText(for: currentWeekIndex))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .contentTransition(.numericText())
                }
                Spacer()
                
                
                Menu {
                    Button { onEdit() } label: { Label("Edit", systemImage: "pencil") }
                    Button(role: .destructive) { onDelete() } label: { Label("Delete", systemImage: "trash") }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.gray)
                        .frame(width: 30, height: 30)
                }
            }
            
            
            TabView(selection: $currentWeekIndex) {
                ForEach(0...historyWeeks, id: \.self) { weekIndex in
                    
                    let days = getDaysForWeek(index: weekIndex)
                    
                    HStack(spacing: 0) {
                        ForEach(days, id: \.self) { date in
                            VStack(spacing: 8) {
                                
                                Text(date.formatted(.dateTime.weekday(.abbreviated)).prefix(3))
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.secondary)
                                
                                
                                let isCompleted = habit.isCompleted(on: date)
                                let color = Color(hex: habit.colorHex)
                                let isFuture = date > Date()
                                
                                Button(action: {
                                    if !isFuture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            habit.toggleCompletion(on: date)
                                        }
                                    }
                                }) {
                                    ZStack {
                                        if isCompleted {
                                            Circle()
                                                .fill(color)
                                            Image(systemName: "checkmark")
                                                .font(.caption2.bold())
                                                .foregroundColor(.white)
                                        } else {
                                            Circle()
                                                .fill(color.opacity(0.1))
                                            if !isFuture {
                                                Circle().stroke(color.opacity(0.3), lineWidth: 1)
                                                
                                            }
                                        }
                                    }
                                    .frame(width: 35, height: 35)
                                    .opacity(isFuture ? 0.3 : 1.0)
                                }
                                .disabled(isFuture)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .tag(weekIndex)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 65)
        }
        .padding(16)
        .background(Color(hex: habit.colorHex).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    func getDaysForWeek(index: Int) -> [Date] {
        let calendar = Calendar.current
        let weeksAgo = index - historyWeeks
        guard let baseDate = calendar.date(byAdding: .weekOfYear, value: weeksAgo, to: Date()) else { return [] }
        return (0..<7).compactMap { i in
            calendar.date(byAdding: .day, value: -((6) - i), to: baseDate)
        }
    }

    func getDateRangeText(for index: Int) -> String {
        if index == historyWeeks {
            return "Last 7 Days"
        }
        let days = getDaysForWeek(index: index)
        guard let first = days.first, let last = days.last else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: first)) - \(formatter.string(from: last))"
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        let habit = Habit(title: "Party", icon: "🎉", colorHex: "#F1C40F", frequency: [1,2,3,4,5,6,7], startDate: Date())
        
        return ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()
            HabitWeeklyCard(habit: habit, onEdit: {}, onDelete: {})
                .padding()
        }
        .modelContainer(container)
    } catch {
        return Text("Error")
    }
}

