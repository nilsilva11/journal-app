//
//  YearlyHeatmapView.swift
//  JournalApp
//
//  Created by Nil Silva on 17/12/2025.
//

import SwiftUI
import SwiftData

struct YearlyHeatmapView: View {
    var habit: Habit
    
    
    var calendarDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        
        guard let oneYearAgo = calendar.date(byAdding: .weekOfYear, value: -52, to: today),
              
              let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: oneYearAgo))
        else { return [] }
        
        return (0..<371).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Yearly Progress")
                .font(.headline)
                .padding(.horizontal)

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    LazyHGrid(rows: Array(repeating: GridItem(.fixed(12), spacing: 4), count: 7), spacing: 4) {
                        
                        ForEach(calendarDays, id: \.self) { date in
                            
                            
                            let isCompleted = habit.isCompleted(on: date)
                            let isFuture = date > Date()
                            let isToday = Calendar.current.isDateInToday(date)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(getColor(isCompleted: isCompleted, isFuture: isFuture))
                                .frame(width: 12, height: 12)
                                .overlay(
                                    isToday ? RoundedRectangle(cornerRadius: 2).stroke(Color.black.opacity(0.3), lineWidth: 1) : nil
                                )
                                .id(date)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 120)
                .onAppear {
                    if let today = calendarDays.last {
                        proxy.scrollTo(today, anchor: .trailing)
                    }
                }
            }
            .background(.white)
            .cornerRadius(16)
            .padding(.horizontal)
        }
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private func getColor(isCompleted: Bool, isFuture: Bool) -> Color {
        if isCompleted {
            return Color(hex: habit.colorHex)
        } else if isFuture {
            return Color.gray.opacity(0.1)
        } else {
            return Color.gray.opacity(0.2)
        }
    }
}


#Preview {
    do {
        
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        
        
        let habit = Habit(
            title: "Code Swift",
            icon: "💻",
            colorHex: "#3498DB",
            frequency: [1, 2, 3, 4, 5],
            startDate: Date()
        )
        
        habit.toggleCompletion(on: Date()) // Hoje
        
        let calendar = Calendar.current
        for i in 1...100 {
            
            if i % 2 == 0 || i % 5 == 0 {
                if let pastDate = calendar.date(byAdding: .day, value: -i, to: Date()) {
                    habit.toggleCompletion(on: pastDate)
                }
            }
        }
        
        return ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            YearlyHeatmapView(habit: habit)
        }
        .modelContainer(container)
        
    } catch {
        return Text("Erro ao criar preview: \(error.localizedDescription)")
    }
}
