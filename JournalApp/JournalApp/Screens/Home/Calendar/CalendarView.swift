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
    
    @Binding var selectedDate: Date
    @Binding var browsingMonth: Date
    @State private var viewModel = CalendarViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    //open month picker
    @State private var showDatePicker: Bool = false
    @State private var tempDate: Date = Date()
    
    //layout
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekDays = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var entries: [DailyEntry]
    
    var monthlyCount: Int {
        let calendar = Calendar.current
        
        
        let entriesInMonth = entries.filter { entry in
            calendar.isDate(entry.date, equalTo: browsingMonth, toGranularity: .month)
        }
    
        let uniqueDays = Set(entriesInMonth.map { calendar.component(.day, from: $0.date) })
        
        return uniqueDays.count
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            //HStack {
            HStack {
                
                Button(action: {
                    tempDate = viewModel.currentMonth
                    showDatePicker = true
                }) {
                    HStack(spacing: 5) {
                        
                        Text(viewModel.currentMonth.formatted(.dateTime.month(.abbreviated)))
                            .fontWeight(.regular)
                        
                        Text(viewModel.currentMonth.formatted(.dateTime.year()))
                            .fontWeight(.regular)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption2.bold())
                    }
                    .font(.subheadline)
                    .foregroundColor(Color("AppAccent"))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .fill(Color("AppAccent").opacity(0.1))
                    )
                }
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color("EntryBall"))
                        .background(
                            Circle()
                                .fill(Color.white)
                                .padding(3)
                        )
                    
                    Text("\(monthlyCount)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Days")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                }
                .padding(.horizontal, 4)
            }
            .padding(.horizontal, 4)
            
            
            
            //week days
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            
            TabView(selection: $viewModel.monthIndex) {
                ForEach(0..<3) { index in
                    LazyVGrid(columns: columns, spacing: 15) {
                        let monthDate = viewModel.months[index]
                        let days = viewModel.getDays(for: monthDate)
                        
                        ForEach(days, id: \.self) { date in
                            let isCurrentMonth = date.isSameMonth(as: monthDate)
                            let isSelected = date.isSameDay(as: selectedDate)
                            let isToday = Calendar.current.isDateInToday(date)
                            let isFuture = date > Date()
                            
                            let hasEntry = entries.contains { entry in
                                Calendar.current.isDate(entry.date, inSameDayAs: date)
                            }
                            
                            //day button
                            Button(action: {
                                if !isFuture {
                                    withAnimation { selectedDate = date }
                                }
                            }) {
                                ZStack {
                                    if isSelected {
                                        Circle()
                                            .fill(Color("AppAccent"))
                                    } else if hasEntry {
                                        
                                        Circle()
                                            .fill(Color("AppAccent").opacity(0.6))
                                    } else if isToday {
                                        Circle()
                                            .stroke(Color("AppAccent"), lineWidth: 1)
                                        
                                    }
                                    
                                    if hasEntry && !isSelected {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    } else {
                                        
                                        Text(date.format("d"))
                                            .font(.system(size: 16))
                                            .fontWeight(isToday || isSelected ? .bold : .regular)
                                            .foregroundColor(
                                                isSelected ? .white :
                                                    (isFuture ? .gray.opacity(0.5) :
                                                        (isCurrentMonth ? .primary : .secondary.opacity(0.7)))
                                            )
                                    }
                                }
                                .frame(width: 35, height: 35)
                            }
                            .buttonStyle(.plain)
                            .disabled(isFuture)
                        }
                    }
                    .tag(index)
                }
            }
            .frame(height: 320)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: viewModel.monthIndex) { oldValue, newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    viewModel.updateMonthIndex(newValue)
                    browsingMonth = viewModel.currentMonth
                }
            }
            .onChange(of: browsingMonth) { _, newDate in
                
                if !Calendar.current.isDate(newDate, equalTo: viewModel.currentMonth, toGranularity: .month) {
                    withAnimation {
                        viewModel.jumpTo(date: newDate)
                    }
                }
            }
            
        }
        .padding()
        
        .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .sheet(isPresented: $showDatePicker) {
            VStack(spacing: 20) {
                Text("Select Month & Year")
                    .font(.headline)
                    .padding(.top, 20)
                
                DatePicker(
                    "Select Date",
                    selection: $tempDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                
                Button(action: {
                    
                    viewModel.jumpTo(date: tempDate)
                    browsingMonth = tempDate
                    showDatePicker = false
                }) {
                    Text("Go to Date")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("AppAccent"))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .presentationDetents([.height(350)])
            .presentationDragIndicator(.visible)
            
        }
        .onAppear {
            viewModel.jumpTo(date: browsingMonth)
            
        }
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = Date()
    @Previewable @State var browsingMonth: Date = Date()
    ZStack {
        Color(UIColor.systemGray6).ignoresSafeArea()
        CalendarView(selectedDate: $selectedDate, browsingMonth: $browsingMonth, entries: [])
    }
}
