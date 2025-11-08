//
//  MainHeaderView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI

struct MainHeaderView: View {
    var body: some View {
        HStack {
            //user and saudation
            Image(systemName: "person.crop.circle.fill") //place for user photo
                .resizable()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
                .foregroundColor(.gray) //grey

            VStack(alignment: .leading, spacing: 2) {
                
                //Text HStack to be able to use different colors
                HStack(spacing: 0) {
                    Text("Hi, ")
                        .fontWeight(.semibold)
                    
                    Text("Sofia")
                        .fontWeight(.bold)
                        .foregroundColor(Color("AppAccent")) //"Sofia Color"
                    
                    Text(" 👋")
                        .fontWeight(.bold)
                }
                .font(.headline) //change font for whole hstack
                
                Text("Friday, 31 October, 2025")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Spacer to right side
            Spacer()
            
            //BELL
            Image(systemName: "bell")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal) // horizontal padding
    }
}

#Preview {
    MainHeaderView()
        
}
