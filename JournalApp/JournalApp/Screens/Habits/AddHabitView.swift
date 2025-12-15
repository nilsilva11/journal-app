//
//  AddHabitView.swift
//  JournalApp
//
//  Created by Nil Silva on 15/12/2025.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var title: String = ""
    @State private var icon: String = "📝"
    @State private var selectedColor: Color = Color("AppAccent")
    
    @State private var selectedDays: Set<Int> = [1, 2, 3, 4, 5, 6, 7]
    @State private var startDate: Date = Date()
    @State private var hasEndDate: Bool = false
    @State private var endDate: Date = Date().addingTimeInterval(86400 * 30)
    
    let colors: [Color] = [
        Color("AppAccent"),Color("Pink1"), Color("Completed"), Color("Green1"), Color("Delete"), Color("Orange1"),Color("Yellow1"), Color("Grey1")
    ]
    
    let weekDays = [
        (id: 2, label: "M"), (id: 3, label: "T"), (id: 4, label: "W"),
        (id: 5, label: "T"), (id: 6, label: "F"), (id: 7, label: "S"), (id: 1, label: "S")
    ]

    var body: some View {
        NavigationStack {
            Form {
    
                VStack(spacing: 10) {
                    ZStack {
                        
                        Circle()
                        
                            .fill(selectedColor.opacity(0.3))
                            .frame(width: 120, height: 120)
                            .shadow(color: selectedColor.opacity(0.3), radius: 15, x: 0, y: 10)
                        
                        TextField("", text: $icon)
                            .font(.system(size: 75))
                            .multilineTextAlignment(.center)
                            .frame(width: 100, height: 100)

                            .background(Color.clear)
                            .onChange(of: icon) { _, newValue in
                                
                                if newValue.count > 1 {
                                    icon = String(newValue.prefix(1))
                                }
                            }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    Text("Tap icon to change")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                

                Section("Habit Name") {
                    TextField("e.g. Morning Meditation", text: $title)
                        .font(.headline)
                        .padding(.vertical, 8)
                }
                
                Section {
                    HStack(spacing: 0) {
                        ForEach(weekDays, id: \.id) { day in
                
                            Text(day.label)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(
                                    ZStack {
                                        if selectedDays.contains(day.id) {
                                            Circle().fill(selectedColor)
                                        } else {
                                            Circle().fill(Color(UIColor.systemGray5))
                                        }
                                        
                                    }
                                )
                                .foregroundColor(selectedDays.contains(day.id) ? .white : .primary)
                                .clipShape(Circle())
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3)) {
                                        if selectedDays.contains(day.id) {

                                            if selectedDays.contains(day.id){
                                                selectedDays.remove(day.id)
                                            }
                                        } else {
                                            selectedDays.insert(day.id)
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.vertical, 5)
                    
                } header: {
                    Text("Repeat Days")
                    
                }
                Section {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .tint(selectedColor)
    
                                    
                    Toggle("Set End Date", isOn: $hasEndDate)
                                        .tint(selectedColor)
                    
                                    
                    if hasEndDate {
                        DatePicker("End Date", selection: $endDate, in: startDate..., displayedComponents: .date)
                            .tint(selectedColor)
                        
                    }
                } header: {
                    Text("Duration")
    
                }
                
                
                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        ForEach(colors, id: \.self) { color in
                            ZStack {
                                Circle()
                                    .fill(color)
                                    .frame(width: 45, height: 45)
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            selectedColor = color
                                        }
                                    }
                                
                                if selectedColor == color {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .shadow(radius: 1)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { // Mudei para "Create" para soar mais pro
                        saveHabit()
                    }
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty || icon.isEmpty) // Bloqueia se não tiver nome ou emoji
                }
            }
        }
    }
    
    func saveHabit() {
        let hexColor = selectedColor.toHex() ?? "#8E44AD"
        let finalIcon = icon.isEmpty ? "✨" : icon
        let frequencyArray = Array(selectedDays)
        let finalEndDate = hasEndDate ? endDate : nil
        
        let newHabit = Habit(
            title: title,
            icon: finalIcon,
            colorHex: hexColor,
            frequency: frequencyArray,
            startDate: startDate,
            endDate: finalEndDate
        )
        
        modelContext.insert(newHabit)
        dismiss()
        
    }
}

#Preview {
    AddHabitView()
        .modelContainer(for: Habit.self, inMemory: true)
}
