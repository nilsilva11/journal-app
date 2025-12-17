//
//  HabitDetailView.swift
//  JournalApp
//
//  Created by Nil Silva on 16/12/2025.
//

import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Bindable var habit: Habit
    @Environment(\.dismiss) var dismiss
    
    @State private var currentMonth: Date = Date()
    @State private var showEditSheet: Bool = false
    
    var body: some View {
        
        ZStack {
            
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(Color(.gray), lineWidth: 1)
                                .fill(.white)
                                .frame(width: 120, height: 120)
                            //.shadow(color: Color(hex: habit.colorHex).opacity(0.3), radius: 10, x: 0, y: 0)
                            
                            Text(habit.icon)
                                .font(.system(size: 60))
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    
                    HabitCalendarView(habit: habit, currentMonth: $currentMonth, color: Color(hex: habit.colorHex))
                    
                    YearlyHeatmapView(habit: habit)
                    
                    HStack(spacing: 15) {
                        
                        //overall
                        StatCard(
                            title: "Total Done",
                            value: "\(habit.completedDates.count)",
                            icon: "checkmark.circle.fill",
                            color: Color(hex: habit.colorHex)
                        )
                        
                        //this month
                        StatCard(
                            title: "This Month",
                            value: "\(getMonthlyCount())",
                            icon: "calendar",
                            color: Color(hex: habit.colorHex)
                        )
                    }
                    .padding(.horizontal)
                    
                    
                    
                    
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(habit.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    showEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            AddHabitView(habitToEdit: habit)
        }
    }
    
    // Função auxiliar para contar dias do mês atual
    func getMonthlyCount() -> Int {
        let calendar = Calendar.current
        return habit.completedDates.filter { date in
            calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
        }.count
    }
}

//habits stats
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        

        ZStack(alignment: .bottomLeading) {
            
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(value)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(color.opacity(0.9))
                Text(title)
                    .font(.subheadline).fontWeight(.medium).foregroundColor(.secondary)
            }
            .padding(20)
            
            
        }
        .frame(height: 150)

    }
}

struct YearlyHeatmapView: View {
    var habit: Habit
    
    
    var calendarDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        
        guard let oneYearAgo = calendar.date(byAdding: .weekOfYear, value: -52, to: today),
              
              let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: oneYearAgo))
        else { return [] }
        
        return (0..<371).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Yearly Progress")
                .font(.headline)
                .padding(.horizontal)

            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    LazyHGrid(rows: Array(repeating: GridItem(.fixed(12), spacing: 4), count: 7), spacing: 4) {
                        
                        ForEach(calendarDays, id: \.self) { date in
                            
                            
                            let isCompleted = habit.isCompleted(on: date)
                            let isFuture = date > Date()
                            let isToday = Calendar.current.isDateInToday(date)
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(getColor(isCompleted: isCompleted, isFuture: isFuture))
                                .frame(width: 12, height: 12)
                                .overlay(
                                    isToday ? RoundedRectangle(cornerRadius: 2).stroke(Color.black.opacity(0.3), lineWidth: 1) : nil
                                )
                                .id(date)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 120)
                .onAppear {
                    if let today = calendarDays.last {
                        proxy.scrollTo(today, anchor: .trailing)
                    }
                }
            }
            .background(.white)
            .cornerRadius(16)
            .padding(.horizontal)
        }
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    func getColor(isCompleted: Bool, isFuture: Bool) -> Color {
        if isCompleted {
            return Color(hex: habit.colorHex)
        } else if isFuture {
            return Color.gray.opacity(0.1)
        } else {
            return Color.gray.opacity(0.2) 
        }
    }
}


//calendar
struct HabitCalendarView: View {
    var habit: Habit
    @Binding var currentMonth: Date
    
    let color: Color
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 20) {
            

            HStack(spacing: 15) {
                
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(color)
                        .padding(5)
                }
                
                Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(color))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .fill(Color(color).opacity(0.15))
                    )
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(color)
                        .padding(5)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDates(), id: \.self) { date in
                    if let date = date {
                        let isCompleted = habit.isCompleted(on: date)
                        let isToday = Calendar.current.isDateInToday(date)
                        let isFuture = date > Date()
                        
                        Button(action: {
                           
                            if !isFuture {
                                withAnimation {
                                    habit.toggleCompletion(on: date)
                                }
                            }
                        }) {
                            ZStack {
                                if isCompleted {
                                    Circle()
                                        .fill(Color(hex: habit.colorHex))
                                }
                                
                                if isToday && !isCompleted {
                                    Circle()
                                        .stroke(Color(hex: habit.colorHex), lineWidth: 2)
                                }
                                
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.caption)
                                    .foregroundColor(isCompleted ? .white : (isFuture ? .gray.opacity(0.3) : .primary))
                            }
                            .frame(height: 35)
                        }
                        .disabled(isFuture)
                        
                    } else {
                        
                        Color.clear.frame(height: 35)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    
    func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    
    func extractDates() -> [Date?] {
        let calendar = Calendar.current
        
        
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let startOfMonth = calendar.date(from: components) else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth) else { return [] }
        
        var days: [Date?] = []
        
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        let habit = Habit(title: "Ler Livro", icon: "📖", colorHex: "8E44AD", frequency: [1,2], startDate: Date())
        habit.toggleCompletion(on: Date())
        
        return NavigationStack {
            ZStack {
                Color(UIColor.systemGray6).ignoresSafeArea()
                HabitDetailView(habit: habit)
            }
        }
        .modelContainer(container)
    } catch {
        return Text("Error preview")
    }
}

