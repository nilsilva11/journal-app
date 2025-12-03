//
//  MonthGoalsCardView.swift
//  JournalApp
//
//  Created by Nil Silva on 11/11/2025.
//

import SwiftUI


    
struct HighlightRow: View {
    
    @State private var showGoal: Bool = false
        
    let goal: Goal
    
    //to open sheet
    let onEdit: (Goal) -> Void
    
    //to make checkboxes clickable
    let onToggle: (Goal) -> Void
    
    //to delete goal from goals list
    let onDelete: (Goal) -> Void
        
    var body: some View {
        HStack(spacing: 15) {
            //entry line
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(goal.isCompleted ? Color("EntryBall") : Color("ProgressCard")) //checkbox
                //checkbox sizw
                    .frame(width: 40, height: 40)
                //rotate
                    .rotationEffect(.degrees(45))
                
                if goal.isCompleted {
                    Image(systemName: "checkmark").bold()
                        .foregroundColor(.white)
                }
       
            }
            .onTapGesture {
                
                withAnimation(.spring()) {
                    onToggle(goal)
                }
            }
                
                //Text(emoji)
                   //.font(.title2)
                
            VStack(alignment: .leading, spacing: 5) {
                
                Text(goal.text)
                    .font(.title3).bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.white)
                
                Text(goal.subtext)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(.white)
                
                    
            }
            .onTapGesture {
                //open edit
                onEdit(goal)
            }
    
                
            Spacer()
        }
        .padding(20)
        .background(
            goal.isCompleted ? Color("AppAccent") : Color("ProgressCard").opacity(0.6)
        )
        .cornerRadius(200) // rounded corners

    }
}
    
    
    
struct MonthGoalsCardView: View {
        
    let completed: [Goal]
    let inProgress: [Goal]
    let onToggle: (Goal) -> Void
    let onEdit: (Goal) -> Void
    let onDelete: (Goal) -> Void
        
    
    var body: some View {
        VStack {
            VStack (alignment: .leading, spacing: 25) {
                Text("👏 Completed")
                    .foregroundColor(.white).opacity(0.7)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.appAccent.opacity(0.7))
                    .cornerRadius(20)
                // aligning title to the left side of the main card
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
                VStack(spacing: 14) {
                    ForEach(completed) { goal in
                        HighlightRow(goal: goal, onEdit: onEdit, onToggle: onToggle, onDelete: onDelete)
     
                    }
                }
            }
        }
        .padding(25) //whole card padding
        .background(
            //main card background color
            Color("AppAccent").opacity(0.5)
        )
        .cornerRadius(30) //rounded corners
        .padding(.horizontal) //lateral padding
        
        
        VStack {
            VStack (alignment: .leading, spacing: 25) {
                Text("💪 In Progress")
                    .foregroundColor(.white).opacity(0.7)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color("ProgressCard").opacity(0.7))
                    .cornerRadius(20)
                // aligning title to the left side of the main card
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
                VStack(spacing: 14) {
                    ForEach(inProgress) { goal in
                        HighlightRow(goal: goal,onEdit: onEdit, onToggle: onToggle, onDelete: onDelete)
                    }
                }
            }
        }
        .padding(25) //whole card padding
        .background(
            //main card background color
            Color("ProgressCard").opacity(0.25)
        )
        .cornerRadius(30) //rounded corners
        .padding(.horizontal) //lateral padding
    }
}


#Preview {
    GoalsView()
}


