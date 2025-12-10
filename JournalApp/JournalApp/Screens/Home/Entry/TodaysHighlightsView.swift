//
//  TodaysHighlightsView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI

struct TodaysHighlightsCard: View {

    // Highlight subcard
    // Repara como tem o seu próprio background e cornerRadius
    struct HighlightRow: View {
        var emoji: String
        var text: String
        
        var body: some View {
            HStack(spacing: 15) {
                //entry line
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 6, height: 30)
                    .foregroundColor((Color.appAccent).opacity(0.5)) //line color
                
                Text(emoji)
                    .font(.title2)
                
                Text(text)
                    .font(.body)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(12)
            .background(
                // background color
                Color.blue.opacity(0.1)
            )
            .cornerRadius(18) // rounded corners
        }
    }
    
    // WHOLE CARD
    var body: some View {
        VStack(spacing: 15) {
            
            // Card title ---
            Text("⭐️ Today's Highlights")
                .foregroundColor(.white)
                .font(.footnote)
                .fontWeight(.bold)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.appAccent.opacity(0.7))
                .cornerRadius(20)
                // aligning title to the left side of the main card
                .frame(maxWidth: .infinity, alignment: .leading)


            // HIGHLIGHTS CONTENT ---
            // hardcoded content
            VStack(spacing: 10) {
                HighlightRow(emoji: "🏃", text: "Running")
                HighlightRow(emoji: "🍽️", text: "Dinner out")
                HighlightRow(emoji: "✅", text: "Finished App")
            }
            

            // --- VIEW & EDIT BUTTON ---
            Button(action: {
                // action - to be developed
                print("View/Edit Entry tapped")
            }) {
                Text("View & Edit Entry")
                    .font(.subheadline)
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
    }
}

#Preview {
    TodaysHighlightsCard()
        .padding()
}
