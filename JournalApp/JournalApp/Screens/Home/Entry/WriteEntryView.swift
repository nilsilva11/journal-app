//
//  WriteEntryView.swift
//  JournalApp
//
//  Created by Nil Silva on 10/12/2025.
//

import SwiftUI

struct WriteEntryView: View {
    @Environment(\.dismiss) var dismiss
    
    //data
    var entryToEdit: DailyEntry?
    var date: Date
    
    var onSave: (String, String) -> Void
    
    @State private var title: String = ""
    @State private var text: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                //date
                Text(date.formatted(date: .complete, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    .padding(.top)
                
                //title
                TextField("Title", text: $title)
                    .font(.title2.bold())
                    .padding(.horizontal)
                
                Divider().padding(.horizontal)
                
            
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Write about your day here...")
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    
                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden)
                }
                .padding(.horizontal)
            }
            .navigationTitle(entryToEdit == nil ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title, text) 
                        dismiss()
                    }
                    .disabled(text.isEmpty && title.isEmpty)
                }
            }
            .onAppear {
                if let entry = entryToEdit {
                    title = entry.title
                    text = entry.text
                }
            }
        }
    }
}

#Preview {
    WriteEntryView(
        date: Date(),
        onSave: { title, text in
            print("Título: \(title), Texto: \(text)")
        }
    )
}
