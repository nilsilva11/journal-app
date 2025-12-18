//
//  MainHeaderView.swift
//  JournalApp
//
//  Created by Nil Silva on 08/11/2025.
//

import SwiftUI

struct MainHeaderView: View {
    var name: String = "Sofia"
    
    var isCalendarExpanded: Binding<Bool>? = nil
    
    
    var onSettingsTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 20) {
            
            HStack(alignment: .center, spacing: 12) {
                
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                    Image(systemName: "person.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
                .frame(width: 45, height: 45)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Good Morning,")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fontWeight(.medium)
                    
                    Text("\(name) 👋")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                if let isExpanded = isCalendarExpanded {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            isExpanded.wrappedValue.toggle()
                        }
                    }) {
                        Image(systemName: isExpanded.wrappedValue ? "rectangle.grid.1x2" : "calendar")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color("AppAccent"))
                            .frame(width: 45, height: 45)
                            .background(
                                Circle()
                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                    .background(Circle().fill(Color.white))
                            )
                            .shadow(color: .black.opacity(0.02), radius: 5, x: 0, y: 2)
                    }
                    
                }
            }
            .padding(.horizontal)
        
        }
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    ZStack {
        Color(UIColor.systemGray6).ignoresSafeArea()
        VStack {
            MainHeaderView(name: "Sofia", isCalendarExpanded: .constant(false))
            Spacer()
        }
    }
}
