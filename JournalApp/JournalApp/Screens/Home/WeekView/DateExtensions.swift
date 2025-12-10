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
    
    //next week
    var nextWeek: Date {
        Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self) ?? self
    }
    
    //previous week
    var previousWeek: Date {
        Calendar.current.date(byAdding: .weekOfYear, value: -1, to: self) ?? self
    }
    
    //days of the month
    func fetchDaysInMonth() -> [Date] {
        let calendar = Calendar.current
    
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: self)) else { return [] }
    
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
    
        let offsetDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        guard let startDay = calendar.date(byAdding: .day, value: -offsetDays, to: firstDayOfMonth) else { return [] }
        
        return (0..<42).compactMap { i in
            calendar.date(byAdding: .day, value: i, to: startDay)
        }
    }
    
    func isSameMonth(as date: Date) -> Bool {
        Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    
    func monthDistance(to otherDate: Date) -> Int {
        let calendar = Calendar.current
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        let end = calendar.date(from: calendar.dateComponents([.year, .month], from: otherDate))!
        
        let components = calendar.dateComponents([.month], from: start, to: end)
        return components.month ?? 0
        
    }
    
    var nextMonth: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: self) ?? self
    }
    
    var previousMonth: Date {
        Calendar.current.date(byAdding: .month, value: -1, to: self) ?? self
    }
    
}
