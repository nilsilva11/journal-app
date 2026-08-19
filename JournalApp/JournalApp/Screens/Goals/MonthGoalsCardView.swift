//
//  MonthGoalsCardView.swift
//  JournalApp
//
//  Created by Nil Silva on 11/11/2025.
//

import SwiftUI
import SwiftData

struct GoalCardRow: View {
    let goal: Goal
    let onEdit: (Goal) -> Void
    let onToggle: (Goal) -> Void
    let onDelete: (Goal) -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 14) {
            // Checkbox button
            Button(action: {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    onToggle(goal)
                }
            }) {
                ZStack {
                    if goal.isCompleted {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color("AppAccent"), Color("AppAccent").opacity(0.85)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                            .shadow(color: Color("AppAccent").opacity(0.35), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Circle()
                            .fill(Color("AppAccent").opacity(0.08))
                            .frame(width: 36, height: 36)
                        
                        Circle()
                            .stroke(Color("AppAccent").opacity(0.35), lineWidth: 1.5)
                            .frame(width: 36, height: 36)
                    }
                }
                .contentShape(Circle())
            }
            .buttonStyle(.plain)
            
            // Goal text & subtext
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(goal.isCompleted ? .secondary : .primary)
                    .strikethrough(goal.isCompleted, color: Color("AppAccent").opacity(0.6))
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                if !goal.subtext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(goal.subtext)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.85))
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                onEdit(goal)
            }
            
            // Options Menu (Edit / Delete)
            Menu {
                Button {
                    onEdit(goal)
                } label: {
                    Label("Edit Goal", systemImage: "pencil")
                }
                
                Button(role: .destructive) {
                    onDelete(goal)
                } label: {
                    Label("Delete Goal", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary.opacity(0.6))
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    goal.isCompleted
                    ? (colorScheme == .dark ? Color("AppAccent").opacity(0.14) : Color("AppAccent").opacity(0.07))
                    : (colorScheme == .dark ? Color(hex: "18181A") : Color(UIColor.secondarySystemGroupedBackground))
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    goal.isCompleted
                    ? Color("AppAccent").opacity(0.25)
                    : Color.gray.opacity(0.12),
                    lineWidth: 1
                )
        )
        .shadow(
            color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04),
            radius: 6,
            x: 0,
            y: 2
        )
    }
}

// Backward compatibility alias in case referenced elsewhere
typealias HighlightRow = GoalCardRow

struct MonthGoalsCardView: View {
    let completed: [Goal]
    let inProgress: [Goal]
    let onToggle: (Goal) -> Void
    let onEdit: (Goal) -> Void
    let onDelete: (Goal) -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 22) {
            // MARK: - In Progress Section
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "target")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color("AppAccent"))
                    
                    Text("In Progress")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary.opacity(0.85))
                    
                    Text("\(inProgress.count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("AppAccent"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color("AppAccent").opacity(0.12))
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                .padding(.horizontal, 18)
                
                if inProgress.isEmpty && !completed.isEmpty {
                    HStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 18))
                            .foregroundColor(Color("AppAccent"))
                        
                        Text("All goals completed this month! 🎉")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(colorScheme == .dark ? Color(hex: "18181A").opacity(0.6) : Color(UIColor.secondarySystemGroupedBackground).opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.gray.opacity(0.12), style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                    )
                    .padding(.horizontal, 15)
                } else {
                    VStack(spacing: 12) {
                        ForEach(inProgress) { goal in
                            GoalCardRow(
                                goal: goal,
                                onEdit: onEdit,
                                onToggle: onToggle,
                                onDelete: onDelete
                            )
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
            
            // MARK: - Completed Section
            if !completed.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color("AppAccent"))
                        
                        Text("Completed")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.primary.opacity(0.85))
                        
                        Text("\(completed.count)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.gray.opacity(0.12))
                            .clipShape(Capsule())
                        
                        Spacer()
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 4)
                    
                    VStack(spacing: 12) {
                        ForEach(completed) { goal in
                            GoalCardRow(
                                goal: goal,
                                onEdit: onEdit,
                                onToggle: onToggle,
                                onDelete: onDelete
                            )
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Goal.self, configurations: config)
        
        let g1 = Goal(text: "Run 50km this month", subtext: "Reach milestone before the 25th", isCompleted: false)
        let g2 = Goal(text: "Read 2 books", subtext: "Atomic Habits and Deep Work", isCompleted: false)
        let g3 = Goal(text: "Meditate 15 mins daily", subtext: "Morning mindfulness session", isCompleted: true)
        
        return ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()
            ScrollView {
                MonthGoalsCardView(
                    completed: [g3],
                    inProgress: [g1, g2],
                    onToggle: { _ in },
                    onEdit: { _ in },
                    onDelete: { _ in }
                )
                .padding(.vertical)
            }
        }
        .modelContainer(container)
    } catch {
        return Text("Preview error")
    }
}
