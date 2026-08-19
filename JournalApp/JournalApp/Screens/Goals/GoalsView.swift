//
//  GoalsView.swift
//  JournalApp
//
//  Created by Nil Silva on 11/11/2025.
//

import SwiftUI
import SwiftData

struct GoalsView: View {
    
    //to save data
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    
    //database
    @Query var allGoals: [Goal]
    
    //viewmodel
    @State private var viewModel = GoalsViewModel()
    
    //to edit goal
    @State private var selectedGoal: Goal? = nil
    
    //to show add goal sheet
    @State private var showSheet: Bool = false
    
    //to know what month is it
    private var currentMonthName: String {
        Date().formatted(.dateTime.month(.wide))
    }
    
    private func getProgressMessage(completed: Int, total: Int) -> String {
        guard total > 0 else { return "Set your intentions for this month" }
        if completed == total {
            return "All goals completed! Excellent work 🎉"
        } else if completed == 0 {
            return "Ready to make progress this month?"
        } else if Double(completed) / Double(total) >= 0.5 {
            return "More than halfway there! Keep going 💪"
        } else {
            return "Great start! Keep up the momentum ✨"
        }
    }
    
    var body: some View {
        
        ZStack {
            
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            ZStack(alignment: .top) {
                
                VStack {
                    UniversalHeaderView(
                        showDate: false
                    )
                }
                .zIndex(1)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Spacer().frame(height: 5)
                        
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(currentMonthName)
                                    .font(.system(size: 25, weight: .regular))
                                    .foregroundColor(.secondary)
                                
                                Text("Monthly Focus")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            if !allGoals.isEmpty {
                                Button(action: {
                                    showSheet = true
                                }) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 44, height: 44)
                                        .background(Color("AppAccent"))
                                        .clipShape(Circle())
                                        .shadow(color: Color("AppAccent").opacity(0.35), radius: 6, x: 0, y: 3)
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 60)
                        .sheet(isPresented: $showSheet) {
                            AddGoalView(onSave: { (text, subtext) in
                                viewModel.addGoal(text: text, subtext: subtext)
                                showSheet = false
                            })
                            .presentationDetents([.height(400)])
                        }
                        .sheet(item: $selectedGoal) { goalToEdit in
                            AddGoalView(
                                goalToEdit: goalToEdit,
                                onSave: { (text, subtext) in
                                    viewModel.updateGoal(goal: goalToEdit, text: text, subtext: subtext)
                                    selectedGoal = nil
                                },
                                onDelete: {
                                    viewModel.deleteGoal(goalToEdit)
                                    selectedGoal = nil
                                }
                            )
                            .presentationDetents([.height(400)])
                        }
                        
                        if allGoals.isEmpty {
                            // --- EMPTY STATE VIEW ---
                            VStack(spacing: 5) {
                                
                                Spacer().frame(height: 50)
                                
                                Image("Journal")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 240)
                                
                                HStack {
                                    Text("Your Goals List is")
                                        .font(.title2)
                                        .fontWeight(.regular)
                                    
                                    Text("Empty")
                                        .foregroundStyle(Color("AppAccent"))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                
                                Text("Let's set new goals!")
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.secondaryLabel))
                                
                                Button(action: {
                                    showSheet = true
                                }) {
                                    Text("Create Goal")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                        .frame(width: 200, height: 50)
                                        .background(Color("AppAccent"))
                                        .clipShape(Capsule())
                                        .shadow(color: Color("AppAccent").opacity(0.4), radius: 10, x: 0, y: 5)
                                }
                                .padding(.top, 10)
                            }
                            .frame(maxWidth: .infinity)
                            
                        } else {
                            let completedCount = viewModel.filterCompleted(goals: allGoals).count
                            let totalCount = allGoals.count
                            let percent = totalCount > 0 ? Int((Double(completedCount) / Double(totalCount)) * 100) : 0
                            
                            VStack(spacing: 20) {
                                // Monthly Progress Overview Card
                                VStack(alignment: .leading, spacing: 14) {
                                    HStack(alignment: .center) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Monthly Progress")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.primary)
                                            
                                            Text(getProgressMessage(completed: completedCount, total: totalCount))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        // Percentage Pill
                                        HStack(spacing: 4) {
                                            Text("\(percent)%")
                                                .font(.system(size: 17, weight: .bold))
                                                .foregroundColor(Color("AppAccent"))
                                            
                                            if percent == 100 && totalCount > 0 {
                                                Image(systemName: "checkmark.seal.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(Color("AppAccent"))
                                            }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color("AppAccent").opacity(0.12))
                                        .clipShape(Capsule())
                                    }
                                    
                                    ProgressBarView(current: Double(completedCount), total: Double(totalCount))
                                    
                                    HStack {
                                        Text("\(completedCount) of \(totalCount) goals completed")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                    }
                                }
                                .padding(18)
                                .background(
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(colorScheme == .dark ? Color(hex: "18181A") : Color(UIColor.secondarySystemGroupedBackground))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color.gray.opacity(0.12), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 6, x: 0, y: 2)
                                .padding(.horizontal, 15)
                                
                                MonthGoalsCardView(
                                    completed: viewModel.filterCompleted(goals: allGoals),
                                    inProgress: viewModel.filterInProgress(goals: allGoals),
                                    onToggle: { goal in
                                        viewModel.toggleGoal(goal)
                                    },
                                    onEdit: { goal in
                                        selectedGoal = goal
                                    },
                                    onDelete: { goal in
                                        viewModel.deleteGoal(goal)
                                    }
                                )
                            }
                            .padding(.top, -10)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, 70, for: .scrollContent)
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
        }
        .contentMargins(.bottom, 70, for: .scrollContent)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Goal.self, configurations: config)
        
        let g1 = Goal(text: "Run 50km this month", subtext: "Reach milestone before the 25th", isCompleted: false)
        let g2 = Goal(text: "Read 2 books", subtext: "Atomic Habits and Deep Work", isCompleted: false)
        let g3 = Goal(text: "Meditate 15 mins daily", subtext: "Morning mindfulness session", isCompleted: true)
        
        container.mainContext.insert(g1)
        container.mainContext.insert(g2)
        container.mainContext.insert(g3)
        
        return GoalsView()
            .modelContainer(container)
    } catch {
        return Text("Preview error")
    }
}
