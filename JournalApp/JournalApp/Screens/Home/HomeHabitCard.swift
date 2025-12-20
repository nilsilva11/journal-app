//
//  HomeHabitCard.swift
//  JournalApp
//
//  Created by Nil Silva on 20/12/2025.
//

import SwiftUI
import SwiftData

struct HomeHabitCard: View {
    var habit: Habit
    var date: Date
    var onToggle: () -> Void
    
    var isCompleted: Bool {
        habit.isCompleted(on: date)
    }
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            onToggle()
        }) {
            ZStack(alignment: .topTrailing) {
            
                VStack(alignment: .leading) {
                    
                    Image(systemName: habit.icon)
                        .font(.system(size: 32))
                        .foregroundColor(Color(hex: habit.colorHex))
                        .symbolEffect(.bounce, value: isCompleted)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(habit.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary.opacity(0.8))
                            .lineLimit(1)
                        
                        Text("Daily Goal")
                            .font(.caption)
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                
                ZStack {
                    Circle()
                        .fill(isCompleted ? Color.white : Color.white.opacity(0.5))
                        .frame(width: 34, height: 34)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: habit.colorHex))
                            .transition(.scale.combined(with: .opacity))
                    } else {
                         Circle()
                            .stroke(Color.black.opacity(0.05), lineWidth: 2)
                            .frame(width: 34, height: 34)
                    }
                }
                .padding(12)
            }
            .frame(width: 140, height: 150)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: habit.colorHex).opacity(0.15))
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Habit.self, configurations: config)
        
        let h1 = Habit(title: "Running", icon: "figure.run", colorHex: "#FF6B6B", frequency: [1], startDate: Date())
        let h2 = Habit(title: "Bicycle", icon: "bicycle", colorHex: "#4ECDC4", frequency: [1], startDate: Date())
        
        h1.toggleCompletion(on: Date())
        
        return ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    HomeHabitCard(habit: h1, date: Date(), onToggle: { withAnimation { h1.toggleCompletion(on: Date()) }})
                    HomeHabitCard(habit: h2, date: Date(), onToggle: { withAnimation { h2.toggleCompletion(on: Date()) }})
                }
                .padding()
            }
            
        }
        .modelContainer(container)
    } catch {
        return Text("Error")
    }
}
