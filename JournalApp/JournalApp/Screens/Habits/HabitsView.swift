//
//  HabitsView.swift
//  JournalApp
//
//  Created by Nil Silva on 15/12/2025.
//

import SwiftUI

struct HabitsView: View {
    var body: some View {
        
        ZStack {
            
            Color(UIColor.systemGray6)
                .ignoresSafeArea()
            
            
            VStack (alignment: .leading, spacing: 15) {
                
                MainHeaderView( name: "Sofia")
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        
                        VStack (alignment: .leading, spacing: -10){
                            Text("Habits")
                            Text("Tracker")
                                .foregroundColor(Color("AppAccent"))
                        }
                        .font(.system(size: 48)).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    HabitsView()
}
