//
//  Goal.swift
//  JournalApp
//
//  Created by Nil Silva on 11/11/2025.
//

import Foundation
import SwiftData

@Model
class Goal: Identifiable {
    var id = UUID()
    var text: String
    var subtext: String
    var isCompleted: Bool
    
    init(text: String, subtext: String, isCompleted: Bool = false) {
        self.text = text
        self.subtext = subtext
        self.isCompleted = isCompleted
    }
}
