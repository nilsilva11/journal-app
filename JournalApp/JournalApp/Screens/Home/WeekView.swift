//
//  WeekView.swift
//  JournalApp
//
//  Created by Nil Silva on 04/12/2025.
//

import SwiftUI

struct WeekView: View {
    
    @Binding var selectedDate: Date //clicked day
    var currentWeek: [Date]
    
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(currentWeek, id: \.self) { date in
                VStack(spacing: 8) {
                    // Dia da semana (Seg, Ter...)
                    Text(date.format("EEE"))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(date.isSameDay(as: selectedDate) ? .white : .gray)
                    
                    // Número do dia (04, 05...)
                    Text(date.format("dd"))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(date.isSameDay(as: selectedDate) ? .white : .primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    ZStack {
                        if date.isSameDay(as: selectedDate) {
                            // Fundo para o dia selecionado (Estilo "AppAccent")
                            Capsule()
                                .fill(Color("AppAccent"))
                                .shadow(radius: 2)
                        } else {
                            // Fundo para dias normais
                            Capsule()
                                .fill(Color.white)
                                .opacity(0.5) // Um pouco transparente
                        }
                    }
                )
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedDate = date
                    }
                }
            }
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    WeekView(
        selectedDate: .constant(Date()),
        currentWeek: [Date(), Date().addingTimeInterval(86400), Date().addingTimeInterval(172800)]

   )
}
