//
//  GoalsViewModel.swift
//  JournalApp
//
//  Created by Nil Silva on 08/12/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class GoalsViewModel {
    
    //access to context to be able to change data
    var modelContext: ModelContext? = nil
    
    //completed goals
    func filterCompleted(goals: [Goal]) -> [Goal] {
        return goals.filter { $0.isCompleted }
    }
   
    //in progress goals
    func filterInProgress(goals: [Goal]) -> [Goal] {
        return goals.filter { !$0.isCompleted }
    }
    
    func addGoal(text: String, subtext: String) {
        let newGoal = Goal(text: text, subtext: subtext, isCompleted: false)
        modelContext?.insert(newGoal)
    }
    
    func toggleGoal(_ goal: Goal) {
        goal.isCompleted.toggle()
        
    }
        
    func deleteGoal(_ goal: Goal) {
        modelContext?.delete(goal)
    }
        
    func updateGoal(goal: Goal, text: String, subtext: String) {
        goal.text = text
        goal.subtext = subtext
    }
    
}
