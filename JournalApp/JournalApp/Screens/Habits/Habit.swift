//
//  Habit.swift
//  JournalApp
//
//  Created by Nil Silva on 15/12/2025.
//

import Foundation
import SwiftData

@Model
class Habit {
    
    var id: UUID
    var title: String
    var icon: String
    var colorHex: String
    var createdAt: Date
    var completedDates: [Date] = []
    var frequency: [Int]
    var startDate: Date
    var endDate: Date?
    
    init(title: String, icon: String, colorHex: String, frequency: [Int], startDate: Date, endDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.colorHex = colorHex
        self.createdAt = Date()
        self.completedDates = []
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
    }
    
    //see if habit is completed
    func isCompleted(on date: Date) -> Bool {
        return completedDates.contains { savedDate in
            Calendar.current.isDate(savedDate, inSameDayAs: date)
        }
    }
    
    func toggleCompletion(on date: Date) {
        if isCompleted(on: date) {
            
            completedDates.removeAll { savedDate in
                Calendar.current.isDate(savedDate, inSameDayAs: date)
            }
        } else {
            
            completedDates.append(date)
        }
    }
    
    
    
}
