//
//  DateExtensions.swift
//  JournalApp
//
//  Created by Nil Silva on 04/12/2025.
//

import Foundation

extension Date {
    
    //return day of the week
    func format(_ format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
    //verify is two dates are the same
    func isSameDay(as date: Date) -> Bool {
            Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    
    //find start of the week
    var startOfWeek: Date {
        
        let calendar = Calendar.current
        // Tenta encontrar o domingo/segunda anterior
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) ?? self
    }
    
    //generate week
    var currentWeek: [Date] {
        
        let calendar = Calendar.current
        let start = self.startOfWeek
        
        return (0..<7).compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day, to: start)
        }
    }
}
