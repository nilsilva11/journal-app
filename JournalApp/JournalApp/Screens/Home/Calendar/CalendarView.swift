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
    
    //open month picker
    @State private var showDatePicker: Bool = false
    @State private var tempDate: Date = Date()
    
    //layout
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekDays = ["Sun","Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                HStack() {
                    
                    Button(action: {
                        tempDate = viewModel.currentMonth
                        showDatePicker = true
                    }) {
                        HStack(spacing: 4) {
                            
                            Text(viewModel.currentMonth.formatted(.dateTime.month(.abbreviated)))
                                .font(.headline).bold()
                            
                            Text(viewModel.currentMonth.formatted(.dateTime.year()))
                                .font(.headline).fontWeight(.regular)
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "chevron.down")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .foregroundColor(Color("AppAccent"))
                    }
                }
            }
            .padding(.horizontal)
            
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
                            
                            //day button
                            Button(action: {
                                withAnimation { selectedDate = date }
                            }) {
                                Text(date.format("d"))
                                    .font(.system(size: 16))
                                    .fontWeight(isToday ? .bold : .regular)
                                    .foregroundColor(
                                        isSelected ? .white :
                                            (isToday ? Color("AppAccent") :
                                                (isCurrentMonth ? .primary : .secondary.opacity(0.3)))
                                    )
                                    .frame(width: 35, height: 35)
                                    .background(
                                        ZStack {
                                            if isSelected { Circle().fill(Color("AppAccent")) }
                                            else if isToday { Circle().stroke(Color("AppAccent"), lineWidth: 1) }
                                        }
                                    )
                            }
                            .buttonStyle(.plain)
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
        
        .background(Color(UIColor.systemGray6))
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
        CalendarView(selectedDate: $selectedDate, browsingMonth: $browsingMonth)
    }
}
