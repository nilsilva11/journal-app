//
//  HomeView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI

struct HomeView: View {
    
    //to show monthly calendar view
    @State private var showCalendarView: Bool = false
    @State private var selectedDate: Date = Date()
    
    
    var currentWeek: [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: selectedDate)
        
        // Encontra o domingo/segunda-feira anterior
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else { return [] }
        let startOfWeek = weekInterval.start
        
        // Gera os 7 dias seguintes
        return (0..<7).compactMap { i in
            calendar.date(byAdding: .day, value: i, to: startOfWeek)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                //header
                MainHeaderView(showGreeting: true, name: "Sofia")
                
                
                // --- QUICK DAYS NAVIGATOR ---
                ZStack(alignment: .leading) {
                    
                    Button(action: {
                        // button fill and unfill
                        
                        withAnimation(.spring()) {
                            showCalendarView.toggle()
                        }
                    }) {
                        Image(systemName: "calendar")
                            .foregroundColor(.appAccent)
                            .font(.title2)
                            .foregroundColor(.blue.opacity(0.5))
                            .padding(8)
                            .background(
                                
                                Circle()
                                    .fill(showCalendarView ? Color("AppAccent").opacity(0.5) : Color(UIColor.systemGray6))
                            )
                        
                    }
                    .padding(.leading, 25)
                    
                    
                    
                    HStack(spacing: 15) {
                        // previous button
                        if showCalendarView {
                            // --- month view ---
                            Button(action: {
                                // TODO: develop logic
                                print("Mês Anterior Tapped")
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.headline.weight(.bold))
                                    .padding(10)
                                    .background(Color("AppAccent"))
                                    .clipShape(Circle())
                            }
                            
                            Text("October") // TODO: make it dinamic
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Button(action: {
                                // TODO: make it to the next month
                                print("Mês Seguinte Tapped")
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.headline.weight(.bold))
                                    .padding(10)
                                    .background(Color("AppAccent"))
                                    .clipShape(Circle())
                            }
                            
                        } else {
                            // --- DAY VIEW ---
                            Button(action: {
                                // TODO: develop changing days
                                print("Last week Tapped")
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.headline.weight(.bold))
                                    .padding(10)
                                    .background(Color("AppAccent"))
                                    .clipShape(Circle())
                            }
                            
                            Text("Week") // TODO: make it dynamic
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Button(action: {
                                // TODO: develop next day logic
                                print("Next week Tapped")
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.headline.weight(.bold))
                                    .padding(10)
                                    .background(Color("AppAccent"))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.vertical, 9)
                    .padding(.horizontal, 15)
                    .background(Color(UIColor.systemGray6)) //card background
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity)
                    .padding() // hstack padding
                }
                //.padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)

                
                //if button is clicked -> calendar appears else todays highlights
                if showCalendarView {
                    //Calendar View
                    CalendarView()
                    TodaysHighlightsCard()
                } else {
                    WeekView(
                        selectedDate: $selectedDate,
                        currentWeek: selectedDate.currentWeek
                    )
                    TodaysHighlightsCard()
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
