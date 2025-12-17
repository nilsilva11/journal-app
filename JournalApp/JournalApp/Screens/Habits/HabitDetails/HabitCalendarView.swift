//
//  HabitCalendarView.swift
//  JournalApp
//
//  Created by Nil Silva on 17/12/2025.
//

import SwiftUI
import SwiftData

struct HabitCalendarView: View {
    var habit: Habit
    @Binding var currentMonth: Date
    
    let color: Color
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 20) {
            

            HStack(spacing: 15) {
                
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(color)
                        .padding(5)
                }
                
                Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(color))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .fill(Color(color).opacity(0.15))
                    )
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(color)
                        .padding(5)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDates(), id: \.self) { date in
                    if let date = date {
                        let isCompleted = habit.isCompleted(on: date)
                        let isToday = Calendar.current.isDateInToday(date)
                        let isFuture = date > Date()
                        
                        Button(action: {
                           
                            if !isFuture {
                                withAnimation {
                                    habit.toggleCompletion(on: date)
                                }
                            }
                        }) {
                            ZStack {
                                if isCompleted {
                                    Circle()
                                        .fill(Color(hex: habit.colorHex))
                                }
                                
                                if isToday && !isCompleted {
                                    Circle()
                                        .stroke(Color(hex: habit.colorHex), lineWidth: 2)
                                }
                                
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.caption)
                                    .foregroundColor(isCompleted ? .white : (isFuture ? .gray.opacity(0.3) : .primary))
                            }
                            .frame(height: 35)
                        }
                        .disabled(isFuture)
                        
                    } else {
                        
                        Color.clear.frame(height: 35)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    
    func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    
    func extractDates() -> [Date?] {
        let calendar = Calendar.current
        
        
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let startOfMonth = calendar.date(from: components) else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth) else { return [] }
        
        var days: [Date?] = []
        
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        
        let habit = Habit(title: "Leitura", icon: "📖", colorHex: "#8E44AD", frequency: [1,2,3,4,5], startDate: Date())
        
        return HabitCalendarView(
            habit: habit,
            currentMonth: .constant(Date()),
            color: Color(hex: "#8E44AD")
        )
        .padding()
        .modelContainer(container)
        
    } catch {
        return Text("Erro ao criar preview")
    }
}
