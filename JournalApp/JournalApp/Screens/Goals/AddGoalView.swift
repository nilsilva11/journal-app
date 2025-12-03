//
//  AddGoalView.swift
//  JournalApp
//
//  Created by Nil Silva on 14/11/2025.
//

import SwiftUI

struct AddGoalView: View {
    
    //to edit goal
    var goalToEdit: Goal?
    
    //function that GoalsView is sending to AddGoalsView
    var onSave: (String, String) -> Void
    
    //function to delete
    var onDelete: (() -> Void)? = nil
    
    let charLimit = 50

    

    //to close sheet
    @Environment(\.dismiss) var dismiss
    
    //vars to store user's text
    @State private var goalText: String = ""
    @State private var goalSubtext: String = ""
    @State private var showDelete: Bool = false
    

    var body: some View {
        
        NavigationView{
            VStack {
                VStack(spacing: 20) {
                    
                    //GOAL TITLE
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Goal Title")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Ex: Running", text: $goalText)
                            .onChange(of: goalText) { oldValue, newValue in
                                if newValue.count > charLimit {
                                    goalText = String(newValue.prefix(charLimit))
                                }
                            }
                            .padding()
                            .background(Color("ProgressCard").opacity(0.1))
                            .cornerRadius(15)
                            .autocorrectionDisabled()
                        

                    }
                    
                    //GOAL DESCRIPTION
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Description (Optional)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Ex: Run 5 km under 20 minutes", text: $goalSubtext)
                            .onChange(of: goalSubtext) { oldValue, newValue in
                                if newValue.count > charLimit {
                                    goalSubtext = String(newValue.prefix(charLimit))
                                }
                            }
                            .padding()
                            .background(Color("ProgressCard").opacity(0.1))
                            .cornerRadius(15)
                            .autocorrectionDisabled()
                        
                    }
                    
                    HStack (spacing: -150) {
                        // --- SAVE BUTTON ---
                        Button(action: {
                            onSave(goalText, goalSubtext)
                        }) {
                            Image(systemName: "square.and.arrow.down")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 16)
                        }
                        .background(Color("AppAccent")) // button calor
                        .cornerRadius(90) //
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10) //space above button //space above button
                        
                        //--- DELETE BUTTON ---
                        if goalToEdit != nil {
                            Button(action: {
                                showDelete = true
                            }) {
                                Image(systemName: "trash")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                            }
                            .background(Color.red.opacity(0.9)) // button calor
                            .cornerRadius(90) //
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 10) //space above button
                            .alert("Delete Goal?", isPresented: $showDelete) {
                                Button("Cancel", role: .cancel) { }
                                Button("Delete", role: .destructive) {
                                    // Ação real de apagar
                                    onDelete?()
                                    //dismiss()
                                }
                            } message: {
                                Text("Are you sure? This action cannot be undone.")
                            }
                        }
                    }
                                        
                    
                }
                
                .padding(25) //whole card padding
                .background(
                    //main card background color
                    Color(UIColor.systemGray6)
                )
                .cornerRadius(30) //rounded corners
                .padding(.horizontal) //lateral padding
                
                Spacer()
            }
            .navigationTitle(goalToEdit == nil ? "New Goal" : "Edit Goal") // bar title
            .navigationBarTitleDisplayMode(.inline) // Título pequeno
            // --- 4. OS BOTÕES NA BARRA ---
            .toolbar {
                // Botão de Cancelar (à esquerda)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action:  {
                        dismiss() //dismiss sheet
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(Color("AppAccent"))
                            .foregroundStyle(.white)
                        
                        
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .onAppear {
            // when seet appears -> see if goaltoEdit
            if let goal = goalToEdit {
                // if it is -> change text and subtext to goal info
                goalText = goal.text
                goalSubtext = goal.subtext
            }
        }
    }
}

#Preview {
    
    AddGoalView(onSave: { (text, subtext) in
        print("Goal guardado: \(text), \(subtext)")
    })
}

