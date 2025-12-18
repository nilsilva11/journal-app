//
//  DailyEntry.swift
//  JournalApp
//
//  Created by Nil Silva on 10/12/2025.
//

import Foundation
import SwiftData

@Model
class DailyEntry: Identifiable {
    
    var id: UUID
    var date: Date
    var title: String
    var text: String
    
    init(date: Date, title: String, text: String) {
        self.id = UUID()
        self.date = date
        self.title = title
        self.text = text
    }
}
