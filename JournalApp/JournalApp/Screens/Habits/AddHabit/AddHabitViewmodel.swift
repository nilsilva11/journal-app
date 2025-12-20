//
//  AddHabitViewmodel.swift
//  JournalApp
//
//  Created by Nil Silva on 17/12/2025.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class AddHabitViewModel {
    
    var title: String = ""
    var icon: String = ""
    var selectedColor: Color = Color("AppAccent")
    var selectedDays: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
    var startDate: Date = Date()
    
    var hasEndDate: Bool = false
    var endDate: Date = Date().addingTimeInterval(86400 * 30)
    
    var habitToEdit: Habit?
    
    let colors: [Color] = [
        Color("AppAccent"), Color("Pink1"), Color("Completed"),
        Color("Green1"), Color("Delete"), Color("Orange1"),
        Color("Yellow1"), Color("Grey1")
    ]
    
    let weekDays = [
        (id: 2, label: "M"), (id: 3, label: "T"), (id: 4, label: "W"),
        (id: 5, label: "T"), (id: 6, label: "F"), (id: 7, label: "S"), (id: 1, label: "S")
    ]
    
    init(habitToEdit: Habit? = nil) {
        self.habitToEdit = habitToEdit
        
        if let habit = habitToEdit {
            self.title = habit.title
            self.icon = habit.icon
            self.selectedColor = Color(hex: habit.colorHex)
            self.selectedDays = Set(habit.frequency)
            self.startDate = habit.startDate
            if let end = habit.endDate {
                self.endDate = end
                self.hasEndDate = true
            }
        }
    }
    
    var isValid: Bool {
        !title.isEmpty && !icon.isEmpty
    }
    
    func save(context: ModelContext) {
        let hexColor = selectedColor.toHex() ?? "#8E44AD"
        let finalIcon = icon.isEmpty ? "✨" : icon
        let frequencyArray = Array(selectedDays)
        let finalEndDate: Date? = hasEndDate ? endDate : nil
        
        if let habit = habitToEdit {
            habit.title = title
            habit.icon = finalIcon
            habit.colorHex = hexColor
            habit.frequency = frequencyArray
            habit.startDate = startDate
            habit.endDate = finalEndDate
        } else {
            let newHabit = Habit(
                title: title,
                icon: finalIcon,
                colorHex: hexColor,
                frequency: frequencyArray,
                startDate: startDate,
                endDate: finalEndDate
            )
            context.insert(newHabit)
        }
    }
    
    func handleIconChange(_ newValue: String) {
        if newValue.count > 1 {
            icon = String(newValue.prefix(1))
        }
    }
}
