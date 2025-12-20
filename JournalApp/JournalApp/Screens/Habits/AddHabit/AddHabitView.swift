//
//  AddHabitView.swift
//  JournalApp
//
//  Created by Nil Silva on 15/12/2025.
//

import SwiftUI
import SwiftData

struct SymbolCategory: Identifiable {
    let id = UUID()
    let title: String
    let symbols: [String]
}

let habitCategories: [SymbolCategory] = [
    SymbolCategory(title: "Health & Fitness", symbols: [
        "figure.walk", "figure.run", "figure.strengthtraining.traditional", "figure.yoga",
        "heart.fill", "lungs.fill", "bolt.heart.fill", "dumbbell.fill"
    ]),
    SymbolCategory(title: "Nutrition", symbols: [
        "drop.fill", "cup.and.saucer.fill", "fork.knife",
        "leaf.fill", "carrot.fill", "takeoutbag.and.cup.and.straw.fill"
    ]),
    SymbolCategory(title: "Sleep", symbols: [
        "bed.double.fill", "moon.fill", "moon.zzz.fill", "zzz", "alarm.fill"
    ]),
    SymbolCategory(title: "Mental Health", symbols: [
        "brain.fill", "brain.head.profile.fill", "sparkles", "wind", "hands.sparkles.fill"
    ]),
    SymbolCategory(title: "Productivity", symbols: [
        "book.fill", "books.vertical.fill", "pencil", "pencil.and.outline",
        "checkmark.circle.fill", "calendar", "clock.fill"
    ]),
    SymbolCategory(title: "House & Routine", symbols: [
        "house.fill", "trash.fill", "washer.fill", "sparkles.rectangle.stack.fill", "bed.double.fill"
    ]),
    SymbolCategory(title: "Work", symbols: [
        "laptopcomputer", "desktopcomputer", "iphone",
        "paintbrush.fill", "camera.fill", "music.note", "headphones"
    ]),
    SymbolCategory(title: "Social", symbols: [
        "person.2.fill", "message.fill", "phone.fill", "face.smiling.fill", "hands.clap.fill", "gift.fill"
    ]),
    SymbolCategory(title: "Growth", symbols: [
        "flame.fill","star.fill", "target", "flag.fill", "chart.line.uptrend.xyaxis",
        "arrow.up.right.circle.fill", "repeat", "infinity"
    ])
]

let habitSymbols = [
    "figure.run", "book.fill", "drop.fill", "bed.double.fill",
    "studentdesk", "fork.knife", "dumbbell.fill", "heart.fill",
    "sun.max.fill", "moon.stars.fill", "banknote.fill", "brain.head.profile",
    "leaf.fill", "paintbrush.fill", "music.note", "laptopcomputer"
]

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var vm: AddHabitViewModel
    @State private var selectedIcon: String = "figure.run" 
    @State private var selectedColor: String = "AppAccent"
    @State private var showIconPicker: Bool = false
    
    init(habitToEdit: Habit?) {
        _vm = State(initialValue: AddHabitViewModel(habitToEdit: habitToEdit))
    }

    var body: some View {
        NavigationStack {
            Form {
                
                VStack(spacing: 10) {
                    ZStack {
                        
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            .fill(.white)
                            .frame(width: 120, height: 120)
                        
                        if vm.icon.isEmpty {
                            VStack(spacing: 5) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray.opacity(0.5))
                                
                            }
                            .transition(.opacity)
                            
                        } else {
                            Image(systemName: vm.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .foregroundColor(vm.selectedColor)
                                .contentTransition(.symbolEffect(.replace))
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        showIconPicker = true

                    }
                    
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
                        .autocorrectionDisabled()
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
                    DatePicker("Start Date", selection: $vm.startDate, in: ...Date(), displayedComponents: .date)
                        .tint(vm.selectedColor)

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
            .sheet(isPresented: $showIconPicker) {
                NavigationStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            ForEach(habitCategories) { category in
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    Text(category.title)
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                        .padding(.leading, 5)
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
                                        ForEach(category.symbols, id: \.self) { symbol in
                                            ZStack {
                                                
                                                if vm.icon == symbol {
                                                    Circle()
                                                        .fill(vm.selectedColor.opacity(0.2))
                                                        .frame(width: 55, height: 55)
                                                }
                                                
                                                Image(systemName: symbol)
                                                    .font(.system(size: 24))
                                                    .foregroundColor(vm.icon == symbol ? vm.selectedColor : .primary)
                                                    .frame(width: 55, height: 55)
                                                    .background(Color.gray.opacity(0.05))
                                                    .clipShape(Circle())
                                                    .onTapGesture {
                                                        vm.icon = symbol
                                                        showIconPicker = false
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("Select Icon")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") { showIconPicker = false }
                        }
                    }
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    AddHabitView(habitToEdit: nil)
        .modelContainer(for: Habit.self, inMemory: true)
}
