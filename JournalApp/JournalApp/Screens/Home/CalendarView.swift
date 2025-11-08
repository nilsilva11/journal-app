//
//  CalendarView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI

//to understand if day is from actual month
struct DayInfo: Hashable {
    let day: Int
    let isCurrentMonth: Bool
}


//monthly view
struct CalendarView: View {
    
    //week days
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    // Definir as colunas para a grelha (7 dias)
    // 'flexible()' significa que cada coluna ocupa o espaço disponível
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 7)
    
    // hardcoded for now
    // days simulation
    let daysInMonth: [DayInfo?] = [
            DayInfo(day: 29, isCurrentMonth: false),
            DayInfo(day: 30, isCurrentMonth: false),
            DayInfo(day: 1, isCurrentMonth: true),
            DayInfo(day: 2, isCurrentMonth: true),
            DayInfo(day: 3, isCurrentMonth: true),
            DayInfo(day: 4, isCurrentMonth: true),
            DayInfo(day: 5, isCurrentMonth: true),
            DayInfo(day: 6, isCurrentMonth: true),
            DayInfo(day: 7, isCurrentMonth: true),
            DayInfo(day: 8, isCurrentMonth: true),
            DayInfo(day: 9, isCurrentMonth: true),
            DayInfo(day: 10, isCurrentMonth: true),
            DayInfo(day: 11, isCurrentMonth: true),
            DayInfo(day: 12, isCurrentMonth: true),
            DayInfo(day: 13, isCurrentMonth: true),
            DayInfo(day: 14, isCurrentMonth: true),
            DayInfo(day: 15, isCurrentMonth: true),
            DayInfo(day: 16, isCurrentMonth: true),
            DayInfo(day: 17, isCurrentMonth: true),
            DayInfo(day: 18, isCurrentMonth: true),
            DayInfo(day: 19, isCurrentMonth: true),
            DayInfo(day: 20, isCurrentMonth: true),
            DayInfo(day: 21, isCurrentMonth: true),
            DayInfo(day: 22, isCurrentMonth: true),
            DayInfo(day: 23, isCurrentMonth: true),
            DayInfo(day: 24, isCurrentMonth: true),
            DayInfo(day: 25, isCurrentMonth: true),
            DayInfo(day: 26, isCurrentMonth: true),
            DayInfo(day: 27, isCurrentMonth: true),
            DayInfo(day: 28, isCurrentMonth: true),
            DayInfo(day: 29, isCurrentMonth: true),
            DayInfo(day: 30, isCurrentMonth: true),
            DayInfo(day: 31, isCurrentMonth: true),
            DayInfo(day: 1, isCurrentMonth: false),
            DayInfo(day: 2, isCurrentMonth: false)
        ]

    var body: some View {
        VStack {
            //Month name
            Text("October")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 5) {
                Circle()
                    .fill(Color.entryBall)
                    .frame(width: 8, height: 8)
                Text("Entry added")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 20)

            // --- Week days ---
            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // --- Calendar grid ---
            // LazyVGrid to make grid
            LazyVGrid(columns: columns, spacing: 18) {
                ForEach(daysInMonth, id: \.self) { dayInfo in
                    if let info = dayInfo {
                        //if is current month -> no opacity
                        DayCell(
                            day: info.day,
                            isCurrentMonth: info.isCurrentMonth,
                            isSelected: (info.day == 31 && info.isCurrentMonth), // Verifica se é o 31 *deste* mês
                            hasEntry: (info.day < 19 && info.isCurrentMonth) //entry simulation
                )
            } else {
                        // Espaço em branco
                        Rectangle().fill(Color.clear)
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(30)
        .padding(.horizontal)
    }
}

// --- DAY CELL ---
// Each day has his own view
struct DayCell: View {
    let day: Int
    var isCurrentMonth: Bool = true
    var isSelected: Bool = false
    var hasEntry: Bool = false
    
    var body: some View {
        
        // ZStack to implement entry small ball
        ZStack(alignment: .topTrailing) {
            
            //Day circle
            Text("\(day)")
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    ZStack {
                        if isSelected {
                            //is day selected
                            Circle()
                                .fill(Color("AppAccent"))
                                .frame(width: 43, height: 43)
                        } else {
                            //normal day
                            Circle().fill(Color.white)
                                .frame(width: 43, height: 43)
                                .shadow(radius: 2, x: 0, y: 1) //shadow
                        }
                    }
                )
                .foregroundColor(isSelected ? .white : (isCurrentMonth ? .black : .gray))
            
            //entry ball
            Circle()
                .fill(Color.entryBall)
                .frame(width: 8, height: 8)
                .opacity(hasEntry ? 1.0 : 0.0) //no entry = no ball
                
                //just figuring out the right position for the ball
                .offset(x: -2, y: 2)

        }
        //day opacity
        .opacity(isCurrentMonth ? 1.0 : 0.4)
    }
}

#Preview {
    CalendarView()
}
