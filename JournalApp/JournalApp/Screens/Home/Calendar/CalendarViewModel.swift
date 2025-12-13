//
//  CalendarViewModel.swift
//  JournalApp
//
//  Created by Nil Silva on 10/12/2025.
//

import Foundation

@Observable
class CalendarViewModel {
    var currentMonth: Date = Date()
    var monthIndex: Int = 1
    
    var months: [Date] {
        [
            currentMonth.previousMonth, //0
            currentMonth,               //1
            currentMonth.nextMonth      //2
        ]
    }
    
    var daysCache: [Date: [Date]] = [:]
    
    init() {
        _ = getDays(for: currentMonth)
    }
    
    func getDays(for month: Date) -> [Date] {
        if let cached = daysCache[month] {
            return cached
        }
        let days = month.fetchDaysInMonth() // A tua extensão
        daysCache[month] = days
        return days
    }
    
    func updateMonthIndex(_ newIndex: Int) {
        if newIndex == 2 {
            currentMonth = currentMonth.nextMonth
            monthIndex = 1
        } else if newIndex == 0 {
            currentMonth = currentMonth.previousMonth
            monthIndex = 1
        }
    }
    
    func jumpTo(date: Date) {
        currentMonth = date
        // Limpa cache antigo se quiseres poupar memória, ou mantém
        
    }
    
    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
}
