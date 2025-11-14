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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                //header
                MainHeaderView()
                
                
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
                                print("Dia Anterior Tapped")
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.headline.weight(.bold))
                                    .padding(10)
                                    .background(Color("AppAccent"))
                                    .clipShape(Circle())
                            }
                            
                            Text("Friday, 31 October") // TODO: make it dynamic
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Button(action: {
                                // TODO: develop next day logic
                                print("Dia Seguinte Tapped")
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
                    //Highlights card
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
