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
        
        
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else { return [] }
        let startOfWeek = weekInterval.start
        
        //generate 7d
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
                HStack(alignment: .center) {
                    
                    //month title
                    Button(action: {
                        withAnimation { selectedDate = Date() } // click to today
                    }) {
                        HStack(spacing: 5) {
                            Text(selectedDate.formatted(.dateTime.month(.wide)))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary.opacity(0.8))
                            
                            Text(selectedDate.formatted(.dateTime.year()))
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Spacer()
                    
                    //calendar view button
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showCalendarView.toggle()
                        }
                    }) {
                        Image(systemName: showCalendarView ? "list.bullet.below.rectangle" : "calendar")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("AppAccent"))
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(Color("AppAccent").opacity(0.1))
                            )
                    }
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 5) 
                    
                    
                    
                    /*HStack(spacing: 15) {
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
                        }
                    }
                    .padding(.vertical, 9)
                    .padding(.horizontal, 15)
                    .background(Color(UIColor.systemGray6)) //card background
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity)
                    .padding() // hstack padding
                     */
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

#Preview {
    HomeView()
}
