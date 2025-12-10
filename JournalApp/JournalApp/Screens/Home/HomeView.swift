//
//  HomeView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI

struct HomeView: View {
    
    //to show monthly calendar view
    @State private var viewModel = HomeViewModel()
    @State private var showCalendarView: Bool = false
    
    @State private var browsingMonth: Date = Date()
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 15) {
            MainHeaderView(showGreeting: true, name: "Sofia")
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    
                    
                    
                    // --- QUICK DAYS NAVIGATOR ---
                    HStack(alignment: .center) {
                        
                        //month title
                        Button(action: {
                            viewModel.resetToToday()
                            browsingMonth = Date()
                        }) {
                            HStack(spacing: 5) {
                                let titleDate = showCalendarView ? browsingMonth : viewModel.selectedDate
                                
                                Text(titleDate.formatted(.dateTime.month(.wide)))
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary.opacity(0.8))
                                
                                Text(titleDate.formatted(.dateTime.year()))
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                    .fontWeight(.medium)
                            }
                            .id(showCalendarView ? "browsing" : "selected")
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
                }
                //.padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                //if button is clicked -> calendar appears else todays highlights
                if showCalendarView {
                    //Calendar View
                    CalendarView(selectedDate: $viewModel.selectedDate, browsingMonth: $browsingMonth)
                    TodaysHighlightsCard()
                } else {
                    TabView(selection: $viewModel.weekIndex) {
                        ForEach(0..<3) { index in
                            WeekView(
                                selectedDate: $viewModel.selectedDate,
                                currentWeek: viewModel.weeks[index]
                            )
                            .tag(index)
                        }
                    }
                    .frame(height: 110)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onChange(of: viewModel.weekIndex) { oldValue, newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.updateWeekIndex(newValue)
                            
                        }
                    }
                    TodaysHighlightsCard()
                }
                Spacer()
            }
            .onChange(of: showCalendarView) {
                if showCalendarView {
                    browsingMonth = viewModel.selectedDate
                }
            }
        }
    }
}


#Preview {
    HomeView()
}
