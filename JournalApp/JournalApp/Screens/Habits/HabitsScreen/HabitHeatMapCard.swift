//
//  HabitHeatMapCard.swift
//  JournalApp
//
//  Created by Nil Silva on 15/12/2025.
//

import SwiftUI

struct HabitHeatmapCard: View {
    let habit: Habit
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    
    let rows = 7
    let columns = 20
    let dotSize: CGFloat = 11
    let spacing: CGFloat = 5
    
    var habitColor: Color {
        Color(hex: habit.colorHex)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
        
            HStack {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.5))
                        .frame(width: 40, height: 40)
                    Text(habit.icon)
                        .font(.system(size: 20))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.title)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Last 20 weeks")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Menu {
                    Button {
                        onEdit()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }

                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.gray)
                        .frame(width: 30, height: 30)
                        .contentShape(Rectangle())
                }
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
                                
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(isCompleted ? habitColor : Color(.white).opacity(0.6))
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
        .background(Color(hex: habit.colorHex).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    

    private func getDateForGrid(col: Int, row: Int) -> Date {
        let calendar = Calendar.current
        let today = Date()
        let weeksAgo = (columns - 1) - col
        let weekday = calendar.component(.weekday, from: today)
        
        guard let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today),
              let weekBase = calendar.date(byAdding: .weekOfYear, value: -weeksAgo, to: startOfWeek),
              let finalDate = calendar.date(byAdding: .day, value: row, to: weekBase)
        else { return Date() }
        
        return finalDate
    }
    
    private func getDayLabel(index: Int) -> String {
        let labels = ["S","M", "T", "W", "T", "F", "S"]
        return labels[index]
    }
    
    private func getFrequencyText() -> String {
        if habit.frequency.count == 7 { return "Everyday" }
        return "\(habit.frequency.count) days/week"
    }
}

#Preview {
    HabitHeatmapCard(
            habit: Habit(title: "Morning Run", icon: "🏃‍♂️", colorHex: "FF5733", frequency: [1,2,4,5], startDate: Date(), endDate: nil),
            onEdit: {},   
            onDelete: {}
        )
        .padding()
        .background(Color(UIColor.systemGray6))
}
