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
    
    @State private var vm: AddHabitViewModel
    
    init(habitToEdit: Habit?) {
        _vm = State(initialValue: AddHabitViewModel(habitToEdit: habitToEdit))
    }

    var body: some View {
        NavigationStack {
            Form {
                
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .stroke(Color(.gray), lineWidth: 1)
                            .fill(.white)
                            .frame(width: 120, height: 120)
                        
                        TextField("", text: $vm.icon)
                            .font(.system(size: 75))
                            .multilineTextAlignment(.center)
                            .frame(width: 100, height: 100)
                            .background(Color.clear)
                            .onChange(of: vm.icon) { _, newValue in
                                vm.handleIconChange(newValue)
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
                    TextField("e.g. Morning Meditation", text: $vm.title)
                        .font(.headline)
                        .padding(.vertical, 8)
                }
                
                Section {
                    HStack(spacing: 0) {
                        ForEach(vm.weekDays, id: \.id) { day in
                            Text(day.label)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(
                                    ZStack {
                                        if vm.selectedDays.contains(day.id) {
                                            Circle().fill(vm.selectedColor)
                                        } else {
                                            Circle().fill(Color(UIColor.systemGray5))
                                        }
                                    }
                                )
                                .foregroundColor(vm.selectedDays.contains(day.id) ? .white : .primary)
                                .clipShape(Circle())
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3)) {
                                        if vm.selectedDays.contains(day.id) {
                                            vm.selectedDays.remove(day.id)
                                        } else {
                                            vm.selectedDays.insert(day.id)
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
                    DatePicker("Start Date", selection: $vm.startDate, displayedComponents: .date)
                        .tint(vm.selectedColor)
                    
                    /*
                    Toggle("Set End Date", isOn: $vm.hasEndDate)
                    if vm.hasEndDate {
                        DatePicker("End Date", selection: $vm.endDate, displayedComponents: .date)
                    }
                    */
                } header: {
                    Text("Duration")
                }
                

                Section("Color") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 20) {
                        ForEach(vm.colors, id: \.self) { color in
                            ZStack {
                                Circle()
                                    .fill(color)
                                    .frame(width: 45, height: 45)
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            vm.selectedColor = color
                                        }
                                    }
                                
                                if vm.selectedColor == color {
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
            .scrollContentBackground(.hidden)
            //blobs
            .background(
                ZStack {
                    Color(UIColor.systemGray6).ignoresSafeArea()
                    
                    Circle()
                        .fill(vm.selectedColor.opacity(0.5))
                        .frame(width: 300, height: 300)
                        .blur(radius: 150)
                        .offset(x: -100, y: -200)
                    
                    Circle()
                        .fill(vm.selectedColor.opacity(0.5))
                        .frame(width: 250, height: 250)
                        .blur(radius: 120)
                        .offset(x: 100, y: 300)
                }
            )
            .navigationTitle(vm.habitToEdit == nil ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(vm.habitToEdit == nil ? "Create" : "Save") {
                        vm.save(context: modelContext) 
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!vm.isValid)
                }
            }
        }
    }
}

#Preview {
    AddHabitView(habitToEdit: nil)
        .modelContainer(for: Habit.self, inMemory: true)
}
