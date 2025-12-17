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
    @State private var activeSheet: SheetConfig?
    
    @State private var showAllNotesSheet: Bool = false
    
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DailyEntry.date, order: .reverse) var allEntries: [DailyEntry]
    
    var todaysEntry: DailyEntry? {
        allEntries.first { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: viewModel.selectedDate)
        }
    }
    
    var todaysEntries: [DailyEntry] {
        allEntries.filter { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: viewModel.selectedDate)
        }
    }
    
    var monthlyEntryCount: Int {
        let calendar = Calendar.current
        
        let entriesInMonth = allEntries.filter { entry in
            calendar.isDate(entry.date, equalTo: viewModel.selectedDate, toGranularity: .month)
        }
        
        let uniqueDays = Set(entriesInMonth.map { calendar.component(.day, from: $0.date) })
        
        return uniqueDays.count
    }
    
    struct SheetConfig: Identifiable {
        let id = UUID()
        let entry: DailyEntry?
    }
    
    var body: some View {
        
        ZStack {
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            VStack (alignment: .leading, spacing: 0) {
                
                VStack{
                    MainHeaderView( name: "Sofia", isCalendarExpanded: $showCalendarView)
                }
                .background(Color.white.ignoresSafeArea(edges: .top))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                .zIndex(1)
                
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
                                    
                                    Text(Date().formatted(.dateTime.weekday(.wide)) + ", " + Date().formatted(.dateTime.day()))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color(.secondaryLabel))
                                }
                                .id(showCalendarView ? "browsing" : "selected")
                                .padding(.top, 20)
                            }
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 15)
                    }
                    //.padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    
                    if showCalendarView {
                        //Calendar View
                        CalendarView(selectedDate: $viewModel.selectedDate, browsingMonth: $browsingMonth, entries: allEntries)
                        journalSection
                    } else {
                        
                        HStack(spacing: 0) {
                            
                            VStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 26))
                                    .foregroundColor(Color("EntryBall"))
                                    
                                HStack (spacing: 3) {
                                    Text("\(monthlyEntryCount)")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    Text("Days")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 2)
                                }
                            }
                            .frame(width: 45)
                            .padding(.leading, 10)
    
                            TabView(selection: $viewModel.weekIndex) {
                                ForEach(0..<3) { index in
                                    WeekView(
                                        selectedDate: $viewModel.selectedDate,
                                        currentWeek: viewModel.weeks[index],
                                        entries: allEntries,
                                    )
                                    .tag(index)
                                }
                            }
                        }
                        .frame(height: 110)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .padding(.top, -23)
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
            .sheet(item: $activeSheet) { config in
                WriteEntryView(
                    entryToEdit: config.entry,
                    date: viewModel.selectedDate,
                    onSave: { title, text in
                        viewModel.saveEntry(
                            context: modelContext,
                            existingEntry: config.entry,
                            title: title,
                            text: text
                        )
                    }
                )
            }
        }
    }
    
    var journalSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            HStack(spacing: 15) {
                
                //open entries
                Button(action: {
                    if !todaysEntries.isEmpty {
                        showAllNotesSheet = true
                    }
                }) {
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(todaysEntries.count)")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(Color("AppAccent"))
                            Text(todaysEntries.count == 1 ? "Note" : "Notes")
                                .font(.subheadline).fontWeight(.medium).foregroundColor(.secondary)
                        }
                        .padding(20)
                    }
                    .frame(height: 150)
                    .opacity(todaysEntries.isEmpty ? 0.6 : 1.0)
                }
                .disabled(todaysEntries.isEmpty)
                .buttonStyle(.plain)
                
                //right button - new entry
                Button(action: {
                    activeSheet = SheetConfig(entry: nil)
                }) {

                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("AppAccent"))
                            .shadow(color: Color("AppAccent").opacity(0.3), radius: 8, x: 0, y: 5)
                        VStack (alignment: .leading, spacing: 5) {
                            Image(systemName: "plus")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(Color("EntryBall").opacity(0.7))
                            Text("New Entry")
                                .font(.subheadline).fontWeight(.medium).foregroundColor(Color("EntryBall").opacity(0.7))
                        }
                        .padding(20)
                    }
                    .frame(height: 150)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
        }
        
        //notes list sheet
        .sheet(isPresented: $showAllNotesSheet) {
            DailyNotesListView(
                entries: todaysEntries,
                onDelete: { entry in modelContext.delete(entry) },
                
                
                onTap: { entry in
                    //close sheet
                    showAllNotesSheet = false
                    
                    //open note
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        activeSheet = SheetConfig(entry: entry)
                    }
                }
            )
            .presentationDetents([.medium, .large])
        }
    }
}


#Preview {
    HomeView()
        .modelContainer(for: DailyEntry.self, inMemory: true)
}
