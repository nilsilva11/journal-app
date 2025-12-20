//
//  WeekView.swift
//  JournalApp
//
//  Created by Nil Silva on 04/12/2025.
//

import SwiftUI

struct WeekView: View {
    
    @Binding var selectedDate: Date //clicked day
    
    @Environment(\.colorScheme) var colorScheme
    var currentWeek: [Date]
    
    var entries: [DailyEntry]
    
    
    var body: some View {
        HStack(spacing: 5) {

            ForEach(currentWeek, id: \.self) { date in
                
                let isSelected = date.isSameDay(as: selectedDate)
                
                let isFuture = date > Date()
                
                let hasEntry = entries.contains { entry in
                    Calendar.current.isDate(entry.date, inSameDayAs: date)
                }
                
                VStack(spacing: 6) {
                    
                    Text(date.format("EEE"))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(isFuture ? .gray.opacity(0.4) : ((isSelected || hasEntry) ? .white : .gray))
                    
                    
                    if hasEntry && !isSelected {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            
                        } else {
                            
                            Text(date.format("dd"))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(isFuture ? .secondary.opacity(0.4) : ((isSelected || hasEntry) ? .white : .primary))
                            
                        }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        
                        if isSelected {
                            
                            Capsule()
                                .fill(Color("AppAccent"))
                                .shadow(color: Color("AppAccent").opacity(0.3), radius: 4, y: 2)
                        } else if hasEntry {
                            
                            Capsule()
                                .fill(Color("AppAccent").opacity(0.6))
                        } else {
                            
                            Capsule()
                                .fill(colorScheme == .dark ? Color.black.opacity(0.5) : Color(UIColor.secondarySystemGroupedBackground))
                                .opacity(0.5)
                        }
   
                    }
                )
                .onTapGesture {
                    if !isFuture {
                        withAnimation(.spring()) {
                            selectedDate = date
                        }       
                    }
                }
            }
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    WeekView(
        selectedDate: .constant(Date()),
        currentWeek: [Date(), Date().addingTimeInterval(86400), Date().addingTimeInterval(172800)],
        entries: []

   )
}
