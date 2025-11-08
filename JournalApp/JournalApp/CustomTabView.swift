//
//  CustomTabView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI

// --- ToolBar -----
struct CustomTabView: View {
    
    // content view link
    @Binding var selectedTab: Int
    
    var body: some View {

        HStack(spacing: 0) {
            
            // --- BUTTON 1: HABITS ---
            Button(action: {
                selectedTab = 0 // TAB 0
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "list.bullet.clipboard.fill")
                        .font(.title3)
                    Text("Habits")
                        .font(.caption)
                }
                // change color if selected
                .foregroundColor(selectedTab == 0 ? .entryBall : .secondary)
                .frame(maxWidth: .infinity) // Ocupa o espaço todo
            }
            
            // --- BUTTON 2: HOME ---
            Button(action: {
                selectedTab = 1 // TAB 1
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "house.fill")
                        .font(.title3)
                    Text("Home")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 1 ? .entryBall : .secondary)
                .frame(maxWidth: .infinity)
            }
            
            // --- BUTTON 3: GOALS ---
            Button(action: {
                selectedTab = 2 // TAB 2
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "target")
                        .font(.title3)
                    Text("Goals")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 2 ? .entryBall : .secondary)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 25) // padding
        .background(Color.white) // <--- background color
        .cornerRadius(30)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
        .padding(.bottom, 10) // up a little
    }
}

#Preview {
    // state has to be false for preview to work
    CustomTabView(selectedTab: .constant(1))
}
