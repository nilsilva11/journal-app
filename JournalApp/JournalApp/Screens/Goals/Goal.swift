//
//  Goal.swift
//  JournalApp
//
//  Created by Nil Silva on 11/11/2025.
//

import Foundation

struct Goal: Identifiable {
    let id = UUID() 
    var text: String
    var subtext: String
    var isCompleted: Bool
}
