//
//  UniversalHeaderView.swift
//  JournalApp
//
//  Created by Nil Silva on 19/12/2025.
//

import SwiftUI

struct UniversalHeaderView: View {

    var showDate: Bool = false
    var isCalendarExpanded: Binding<Bool>? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            

            ZStack {
                
                if showDate {
                    Text(Date().formatted(.dateTime.weekday(.wide)) + ", " + Date().formatted(.dateTime.day()))
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.secondaryLabel))
                }
                
                HStack {
                    // Avatar
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            .frame(width: 50, height: 50)
                        
                        Image("user")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    
                    if let isExpanded = isCalendarExpanded {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isExpanded.wrappedValue.toggle()
                            }
                        }) {
                            Image(isExpanded.wrappedValue ? "weekly" : "calendar")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22, height: 22)
                                .foregroundColor(.primary)
                                .frame(width: 50, height: 50)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                .overlay(
                                    Circle().stroke(Color.gray.opacity(0.1), lineWidth: 1)
                                )
                        }
                    }
                }
                
            }
            .padding(.bottom, 5)
        }
        .padding(.horizontal, 15)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color(UIColor.systemGray6))
    }
}

#Preview {
    ZStack {
        Color(UIColor.systemGray6).ignoresSafeArea()
        VStack {
            UniversalHeaderView(

                showDate: true,
                isCalendarExpanded: .constant(false)
            )
            Spacer()
        }
    }
}
