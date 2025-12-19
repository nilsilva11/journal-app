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
    
    
    var body: some View {
        
        ZStack {
            
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            
            ZStack(alignment: .top) {
                
                VStack{
                    UniversalHeaderView(
                        showDate: false,
                    )
                }
                .zIndex(1)
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Spacer().frame(height: 10)
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Text(currentMonthName)
                                .font(.system(size: 25, weight: .regular))
                                .foregroundColor(.secondary)
                            
                            HStack(alignment: .firstTextBaseline) {
                                Text("Goals")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(.primary)
                                
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 60)
                        .sheet(isPresented: $showSheet) {
                            
                            AddGoalView(onSave: { (text, subtext) in
                                
                                // add goal
                                viewModel.addGoal(text: text, subtext: subtext)
                                
                                showSheet = false // 3. close sheet
                            })
                            // bottomsheet
                            .presentationDetents([.height(400)])
                        }
                        .sheet(item: $selectedGoal) { goalToEdit in
                            
                            AddGoalView(
                                //choose goal that was stored
                                goalToEdit: goalToEdit,
                                onSave: { (text, subtext) in
                                    
                                    //edit
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
                            

                            VStack(spacing: 20) {
                                HStack {
                                    let completedCount = viewModel.filterCompleted(goals: allGoals).count
                                    let totalCount = allGoals.count
                                    
                                    VStack (alignment: .leading, spacing: 5){
                                        Text("\(completedCount) of \(totalCount) Completed")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .padding(.horizontal)
                                        
                                        ProgressBarView(current: Double(completedCount), total: Double(totalCount))
                                            .padding(.horizontal)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                
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

                
                
                Spacer()//to get everything up
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
        }
        .contentMargins(.bottom, 70, for: .scrollContent)
    }
    
}


#Preview {
    GoalsView()
        .modelContainer(for: Goal.self, inMemory: true)
}
