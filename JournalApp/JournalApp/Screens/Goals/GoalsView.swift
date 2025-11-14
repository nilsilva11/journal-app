//
//  GoalsView.swift
//  JournalApp
//
//  Created by Nil Silva on 11/11/2025.
//

import SwiftUI

struct GoalsView: View {
    
    //to show add goal sheet
    @State private var showSheet: Bool = false
    
    //list of goals
    @State private var allGoals: [Goal] = [
        
        Goal(text: "Read", subtext: "Finish my book", isCompleted: true),
        Goal(text: "Study", subtext: "Pass all my exams", isCompleted: true),
        Goal(text: "Running", subtext: "Run an half marathon", isCompleted: false)
    ]
    
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
    
    func toggleCompletion(for toggledGoal: Goal) {
        
        //find goal
        if let index = allGoals.firstIndex(where: { $0.id == toggledGoal.id }) {
            
            //invert completion state of goal
            allGoals[index].isCompleted.toggle()
        }
    }
    
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                MainHeaderView()
                   
                
                //page title
                VStack (alignment: .leading, spacing: -10){
                    Text("October") //TODO: make it dynamic
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
                        
                        withAnimation {
                            allGoals.append(newGoal)
                        }
                        
                        showSheet = false // 3. close sheet
                    })
                    // bottomsheet
                    .presentationDetents([.height(400)])
                }
                
                
                MonthGoalsCardView(completed: completedGoals,
                                   inProgress: inProgressGoals,
                                   onToggle: toggleCompletion)
                
                
                Spacer()//to get everything up
            }
        }
    }
}

#Preview {
    GoalsView()
}
