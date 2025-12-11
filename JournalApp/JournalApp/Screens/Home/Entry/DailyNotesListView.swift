//
//  DailyNotesListView.swift
//  JournalApp
//
//  Created by Nil Silva on 11/12/2025.
//

import SwiftUI

struct DailyNotesListView: View {
    var entries: [DailyEntry]
    var onDelete: (DailyEntry) -> Void
    var onTap: (DailyEntry) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(entries) { entry in
                
                    Button(action: {
                        onTap(entry)
                    }) {
                        VStack(alignment: .leading, spacing: 8) {
                            if !entry.title.isEmpty {
                                Text(entry.title).font(.headline)
                            }
                            Text(entry.text)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(4)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.vertical, 5)
                    }
                    .buttonStyle(.plain)
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        onDelete(entries[index])
                    }
                }
            }
            .navigationTitle("Today's Thoughts")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DailyNotesListView(
        
        entries: [
            DailyEntry(
                date: Date(),
                title: "Exemplo 1",
                text: "Hoje acordei cedo e fui correr."
            ),
            DailyEntry(
                date: Date(),
                title: "Ideia para App",
                text: "Fazer uma funcionalidade de widgets."
            )
        ],

        onDelete: { _ in },
        onTap: { _ in }
    )
}
