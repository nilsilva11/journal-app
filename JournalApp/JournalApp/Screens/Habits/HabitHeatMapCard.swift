//
//  HabitHeatMapCard.swift
//  JournalApp
//
//  Created by Nil Silva on 15/12/2025.
//

import SwiftUI

struct HabitHeatmapCard: View {
    let habit: Habit
    
    
    let rows = 7
    let columns = 15
    let dotSize: CGFloat = 10
    let spacing: CGFloat = 6
    
    var habitColor: Color {
        Color(hex: habit.colorHex)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
        
            HStack {
                ZStack {
                    Circle()
                        .fill(habitColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    Text(habit.icon)
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(getFrequencyText())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .foregroundStyle(.gray)
            }
            
            
            HStack(spacing: 8) {
                
                VStack(spacing: spacing) {
                    ForEach(0..<rows, id: \.self) { index in
                        Text(getDayLabel(index: index))
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.secondary)
                            .frame(height: dotSize)
                    }
                }
                
                HStack(spacing: spacing) {
                    ForEach(0..<columns, id: \.self) { col in
                        VStack(spacing: spacing) {
                            ForEach(0..<rows, id: \.self) { row in
                                
                                let date = getDateForGrid(col: col, row: row)
                                let isCompleted = habit.isCompleted(on: date)
                                let isFuture = date > Date()
                                
                                Circle()
                                    .fill(isCompleted ? habitColor : Color(UIColor.systemGray6))
                                    .opacity(isFuture ? 0 : 1)
                                    .frame(width: dotSize, height: dotSize)
                            }
                        }
                    }
                }
            }
            .padding(.top, 5)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    

    func getDateForGrid(col: Int, row: Int) -> Date {
        let calendar = Calendar.current
        let today = Date()
        let weeksAgo = (columns - 1) - col
        let weekday = calendar.component(.weekday, from: today)
        
        guard let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 2), to: today),
              let weekBase = calendar.date(byAdding: .weekOfYear, value: -weeksAgo, to: startOfWeek),
              let finalDate = calendar.date(byAdding: .day, value: row, to: weekBase)
        else { return Date() }
        
        return finalDate
    }
    
    func getDayLabel(index: Int) -> String {
        let labels = ["M", "T", "W", "T", "F", "S", "S"]
        return labels[index]
    }
    
    func getFrequencyText() -> String {
        if habit.frequency.count == 7 { return "Everyday" }
        return "\(habit.frequency.count) days/week"
    }
}

#Preview {
    HabitHeatmapCard(
            habit: Habit(title: "Morning Run", icon: "🏃‍♂️", colorHex: "FF5733", frequency: [1,2,4,5], startDate: Date(), endDate: nil)
        )
        .padding()
        .background(Color(UIColor.systemGray6))
}
