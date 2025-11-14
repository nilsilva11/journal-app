//
//  AddGoalView.swift
//  JournalApp
//
//  Created by Nil Silva on 14/11/2025.
//

import SwiftUI

struct AddGoalView: View {
    
    //function that GoalsView is sending to AddGoalsView
    var onSave: (String, String) -> Void
    
    //to close sheet
    @Environment(\.dismiss) var dismiss
    
    //vars to store user's text
    @State private var goalText: String = ""
    @State private var goalSubtext: String = ""
    

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
                            .padding()
                            .background(Color("LightBar").opacity(0.5))
                            .cornerRadius(15)
                            .autocorrectionDisabled()
                    }
                    
                    //GOAL DESCRIPTION
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Description (Optional)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Ex: Run 5 km under 20 minutes", text: $goalSubtext)
                            .padding()
                            .background(Color("LightBar").opacity(0.5))
                            .cornerRadius(15)
                            .autocorrectionDisabled()
                    }
                    
                    
                    // --- SAVE BUTTON ---
                    Button(action: {
                        onSave(goalText, goalSubtext)
                    }) {
                        Text("Save")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 35)
                    }
                    .background(Color("AppAccent")) // button calor
                    .cornerRadius(20) //
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10) //space above button
                                        
                    
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
            .navigationTitle("New Goal") // Título na barra
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
    }
}

#Preview {
    
    AddGoalView(onSave: { (text, subtext) in
        print("Goal guardado: \(text), \(subtext)")
    })
}
