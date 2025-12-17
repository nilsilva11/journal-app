//
//  HabitsViewModel.swift
//  JournalApp
//
//  Created by Nil Silva on 17/12/2025.
//

import SwiftUI
import SwiftData

@Observable
class TrackerViewModel {

    var selectedViewType: String = "Weekly"
    var showAddSheet: Bool = false
    var habitToEdit: Habit?
    
    let viewTypes = ["Weekly", "Expanded"]
    
    
    func startCreating() {
        habitToEdit = nil
        showAddSheet = true
    }
    
    func startEditing(_ habit: Habit) {
        habitToEdit = habit
        showAddSheet = true
    }
    
    func deleteHabit(_ habit: Habit, context: ModelContext) {
        context.delete(habit)
        
        if habitToEdit == habit {
            habitToEdit = nil
            showAddSheet = false
        }
    }
}
