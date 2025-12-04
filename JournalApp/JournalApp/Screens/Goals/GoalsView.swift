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
    
    //to edit goal
    @State private var selectedGoal: Goal? = nil
    
    //to show add goal sheet
    @State private var showSheet: Bool = false
    
    //database
    @Query var allGoals: [Goal]

    
    //completed goals
    var completedGoals: [Goal] {
        allGoals.filter { $0.isCompleted }
    }
   
    //in progress goals
    var inProgressGoals: [Goal] {
        allGoals.filter { !$0.isCompleted }
    }
    
    //how many completed goals
    var completedCount: Int {
        completedGoals.count
    }
    
    //completed + in progress
    var totalCount: Int {
        allGoals.count
    }
    
    //to know what month is it
    private var currentMonthName: String {
        Date().formatted(.dateTime.month(.wide)) 
    }

    
    func toggleCompletion(for toggledGoal: Goal) {
        
        toggledGoal.isCompleted.toggle()
    }
    
    func openGoalSheet(for goal: Goal) {
        
        //to open goal info sheet
        selectedGoal = goal //to store tapped goal's info

    }
    
    func deleteGoal(goalToDelete: Goal) {
        
        // to remove goal
        modelContext.delete(goalToDelete)
    }
    
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                MainHeaderView(showGreeting: false, name: "Sofia")
                   
                
                //page title
                VStack (alignment: .leading, spacing: -10){
                    Text(currentMonthName)
                    Text("Goals")
                        .foregroundColor(Color("AppAccent"))
                }
                .font(.system(size: 48)).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                HStack {
                    VStack (alignment: .leading, spacing: 5){
                        Text("\(completedCount) of \(totalCount) Completed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        ProgressBarView(current: Double(completedCount), total: Double(totalCount))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                    }
                    
                    Button(action: {
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
                    .padding(.horizontal)
                }
                .sheet(isPresented: $showSheet) {
                    
                    AddGoalView(onSave: { (text, subtext) in
                        
                        // add goal to list
                        let newGoal = Goal(text: text, subtext: subtext, isCompleted: false)
                        modelContext.insert(newGoal)
                        
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
                                goalToEdit.text = text
                                goalToEdit.subtext = subtext
                            
                                selectedGoal = nil
                    
                        },
                        
                        onDelete: {
                            
                                modelContext.delete(goalToEdit)
                                selectedGoal = nil
                        }
                    )
                    .presentationDetents([.height(400)])
                }
                
                
                MonthGoalsCardView(completed: completedGoals,
                                   inProgress: inProgressGoals,
                                   onToggle: toggleCompletion,
                                   onEdit: openGoalSheet,
                                   onDelete: deleteGoal)
                
                
                Spacer()//to get everything up
            }
        }
    }
}

#Preview {
    GoalsView()
        .modelContainer(for: Goal.self, inMemory: true)
}
