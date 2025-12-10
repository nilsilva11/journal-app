//
//  EntryCards.swift
//  JournalApp
//
//  Created by Nil Silva on 10/12/2025.
//

import SwiftUI

//empty card
struct EmptyEntryCard: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: "square.and.pencil")
                    .font(.largeTitle)
                    .foregroundColor(Color("AppAccent"))
                
                Text("How was your day?")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Write about it to clear your mind.")
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

//preview card
struct EntryPreviewCard: View {
    let entry: DailyEntry
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 15) {
                
                Capsule()
                    .fill(Color("EntryBall").opacity(0.3))
                    .frame(width: 4)
                    .padding(.vertical, 5)
                
                VStack(alignment: .leading, spacing: 6) {
                    //date
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption2)
                        .foregroundColor(.white)
                        .textCase(.uppercase)
                    
                    //title
                    Text(entry.title.isEmpty ? "No Title" : entry.title)
                        .autocorrectionDisabled()
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    //text
                    Text(entry.text)
                        .autocorrectionDisabled()
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("EntryBall").opacity(0.7))
                    .padding(.top, 5)
            }
            .padding(20)
            .background(Color("AppAccent").opacity(0.7))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    ZStack {
        Color(UIColor.systemGray6).ignoresSafeArea()
        
        VStack(spacing: 20) {
            //empty card
            EmptyEntryCard(action: {})
            
            //hardcoded data
            EntryPreviewCard(
                entry: DailyEntry(
                    date: Date(),
                    title: "Exemplo de Título",
                    text: "Hoje foi um dia produtivo. Consegui acabar a funcionalidade do calendário e aprendi muito sobre SwiftData."
                ),
                action: {}
            )
        }
        .padding()
    }
}
