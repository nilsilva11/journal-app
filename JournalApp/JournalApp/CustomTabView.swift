//
//  CustomTabView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI

struct CustomTabView: View {
    
    @Binding var selectedTab: Int
    
    var body: some View {

        VStack(spacing: 0) {
            
            
            Divider()
                .background(Color.gray.opacity(0.1))
            
            HStack(spacing: 0) {
                
                // --- BUTTON 1: HABITS ---
                TabBarButton(image: "list.bullet.clipboard.fill", text: "Habits", isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                // --- BUTTON 2: HOME ---
                TabBarButton(image: "house.fill", text: "Home", isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                // --- BUTTON 3: GOALS ---
                TabBarButton(image: "target", text: "Goals", isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .padding(.top, 12) //space between line and icons
            .padding(.bottom, 2) //space between icons and home bar
        }
        .background(Color.white) // Fundo Branco
        //simple shadow
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: -2)
    }
}

//buttons
struct TabBarButton: View {
    let image: String
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) { //icon and text
                Image(systemName: image)
                    .font(.system(size: 22)) //icon size
                
                //text
                Text(text)
                    .font(.caption2)
                    .fontWeight(isSelected ? .bold : .regular)
            }
            .foregroundColor(isSelected ? Color("EntryBall") : Color.gray.opacity(0.4))
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        Color.gray.ignoresSafeArea()
        CustomTabView(selectedTab: .constant(1))
    }
}
