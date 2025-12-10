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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                //header
                MainHeaderView(showGreeting: true, name: "Sofia")
                
                
                // --- QUICK DAYS NAVIGATOR ---
                HStack(alignment: .center) {
                    
                    //month title
                    Button(action: {
                        viewModel.resetToToday()
                    }) {
                        HStack(spacing: 5) {
                            Text(viewModel.selectedDate.formatted(.dateTime.month(.wide)))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary.opacity(0.8))
                            
                            Text(viewModel.selectedDate.formatted(.dateTime.year()))
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
            }
            //.padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            //if button is clicked -> calendar appears else todays highlights
            if showCalendarView {
                //Calendar View
                CalendarView()
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
    }
}


#Preview {
    HomeView()
}
