//
//  StatCard.swift
//  JournalApp
//
//  Created by Nil Silva on 17/12/2025.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        

        ZStack(alignment: .bottomLeading) {
            
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(value)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(color.opacity(0.9))
                Text(title)
                    .font(.subheadline).fontWeight(.medium).foregroundColor(.secondary)
            }
            .padding(20)
            
            
        }
        .frame(height: 150)

    }
}

#Preview {
    ZStack {
        Color(UIColor.systemGray6).ignoresSafeArea()
        
        HStack(spacing: 15) {
            StatCard(title: "Done", value: "10", icon: "check", color: .green)
            StatCard(title: "Missed", value: "2", icon: "xmark", color: .red)
        }
        .padding()
    }
}
