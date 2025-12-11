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
            
            
            VStack (alignment: .leading, spacing: 15) {
                
                MainHeaderView(showGreeting: false, name: "Sofia")
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        
                        VStack (alignment: .leading, spacing: -10){
                            Text(currentMonthName)
                            Text("Goals")
                                .foregroundColor(Color("AppAccent"))
                        }
                        .font(.system(size: 48)).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
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
                            
                            /*Button(action: {
                             showSheet.toggle()
                             
                             
                             }) {
                             Image(systemName: "plus")
                             .font(.headline)
                             .padding()
                             .background(Color("AppAccent"))
                             .foregroundColor(.white)
                             .clipShape(Circle())
                             }
                             //.frame(maxWidth: .infinity, alignment: .trailing)
                             .padding(.horizontal)*/
                        }
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
                        
                        
                        MonthGoalsCardView(
                            completed: viewModel.filterCompleted(goals: allGoals),
                            inProgress: viewModel.filterInProgress(goals: allGoals),
                            onToggle: { goal in
                                viewModel.toggleGoal(goal) // Ação delegada ao VM
                            },
                            onEdit: { goal in
                                selectedGoal = goal
                            },
                            onDelete: { goal in
                                viewModel.deleteGoal(goal) // Ação delegada ao VM
                                
                            }
                        )
                        
                        
                        Spacer()//to get everything up
                    }
                }
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    Button(action: {
                        showSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56) //
                            .background(Color("AppAccent"))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                }
                .onAppear {
                    viewModel.modelContext = modelContext
                }
                .contentMargins(.bottom, 70, for: .scrollContent)
            }
        }
    }
}

#Preview {
    GoalsView()
        .modelContainer(for: Goal.self, inMemory: true)
}
