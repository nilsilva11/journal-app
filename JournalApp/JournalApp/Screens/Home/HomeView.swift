//
//  HomeView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    //to show monthly calendar view
    @State private var viewModel = HomeViewModel()
    @State private var showCalendarView: Bool = false
    
    @State private var browsingMonth: Date = Date()
    @State private var showEntrySheet: Bool = false
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DailyEntry.date, order: .reverse) var allEntries: [DailyEntry]
    
    var todaysEntry: DailyEntry? {
        allEntries.first { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: viewModel.selectedDate)
        }
    }
    
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
                    journalSection
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
                    journalSection
                }
                Spacer()
            }
            .onChange(of: showCalendarView) {
                if showCalendarView {
                    browsingMonth = viewModel.selectedDate
                }
            }
        }
        .sheet(isPresented: $showEntrySheet) {
            WriteEntryView(
                entryToEdit: todaysEntry,
                date: viewModel.selectedDate,
                onSave: { title, text in
                    viewModel.saveEntry(
                        context: modelContext,
                        existingEntry: todaysEntry,
                        title: title,
                        text: text
                            
                    )
                }
            )
        }
    }
    
    var journalSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Thoughts")
                .font(.headline)
                .padding(.horizontal)
            
            if let entry = todaysEntry {
               
                EntryPreviewCard(entry: entry) {
                    showEntrySheet = true
                }
                .padding(.horizontal)
            } else {
                
                EmptyEntryCard {
                    showEntrySheet = true
                }
                .padding(.horizontal)
            }
        }
    }
}


#Preview {
    HomeView()
        .modelContainer(for: DailyEntry.self, inMemory: true)
}
