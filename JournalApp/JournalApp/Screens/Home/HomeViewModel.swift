//
//  HomeViewModel.swift
//  JournalApp
//
//  Created by Nil Silva on 10/12/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class HomeViewModel {
    var selectedDate: Date = Date() //clicked day
    var weekIndex: Int = 1 // 0: past - 1: present - 2: future
    
    //current date
    var currentWeekStart: Date = Date()
    
    //generate all necessary weeks for infinit swipe through weeks
    var weeks: [[Date]] {
        [
            currentWeekStart.previousWeek.currentWeek, //0
            currentWeekStart.currentWeek,              //1
            currentWeekStart.nextWeek.currentWeek      //2
        ]
    }
    
    //swipe
    func updateWeekIndex(_ newIndex: Int) {
        
        if newIndex == 2 {
            currentWeekStart = currentWeekStart.nextWeek
            selectedDate = currentWeekStart
            weekIndex = 1
        }
        
        else if newIndex == 0 {
            currentWeekStart = currentWeekStart.previousWeek
            selectedDate = currentWeekStart
            weekIndex = 1
        }
    }
    
    //back to present
    func resetToToday() {
        selectedDate = Date()
        currentWeekStart = Date().startOfWeek
        weekIndex = 1
    }
    
    func saveEntry(context: ModelContext, existingEntry: DailyEntry?, title: String, text: String) {
        if let existingEntry = existingEntry {
            //edit
            existingEntry.title = title
            existingEntry.text = text
            
        } else {
            //create
            let newEntry = DailyEntry(
                date: selectedDate,
                title: title,
                text: text
            )
            context.insert(newEntry)
        }
        
        try? context.save()
    }
    
    func getHabitsForSelectedDate(from allHabits: [Habit]) -> [Habit] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: selectedDate)
        
        let selectedDay = calendar.startOfDay(for: selectedDate)
    
        return allHabits.filter { habit in
            let habitStartDay = calendar.startOfDay(for: habit.startDate)
            let isAfterStartDate = selectedDay >= habitStartDay
            let isCorrectDay = habit.frequency.contains(weekday)
            
            return isAfterStartDate && isCorrectDay  
        }
    }
    
    func toggleHabit(_ habit: Habit) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            
            habit.toggleCompletion(on: selectedDate)
        }
    }
}

