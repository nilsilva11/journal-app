//
//  ProgressBarView.swift
//  JournalApp
//
//  Created by Nil Silva on 11/11/2025.
//

import SwiftUI

//progress bar - ai generated
struct ProgressBarView: View {
    
    //done value
    let current: Double
    //total to dos
    let total: Double
    
    //to know percent
    // ex: 2 / 3 = 0.66
    private var progress: Double {
        if total == 0 { return 0 } // Evitar divisão por zero
        return current / total
    }
    
    var body: some View {
        
        // O GeometryReader dá-nos o "proxy" (o tamanho do contentor)
        // para sabermos qual é 100% da largura.
        GeometryReader { proxy in
            // A ZStack permite-nos sobrepôr as duas barras:
            // 1. O fundo (a "calha")
            // 2. O progresso (a "barra preenchida")
            ZStack(alignment: .leading) {
                
                // --- 1. A BARRA DE FUNDO ("Calha") --
                Capsule()
                    .fill(Color("LightBar")) // A tua cor de fundo clara
                    .frame(height: 8) // Define a altura da barra
                
                // --- 2. A BARRA DE PROGRESSO (Preenchida) ---
                Capsule()
                    .fill(Color("AppAccent")) // A tua cor de acento
                    // A "magia" está aqui:
                    // A largura é a largura total (proxy.size.width)
                    // multiplicada pela nossa percentagem (self.progress)
                    .frame(width: proxy.size.width * self.progress, height: 8)
            }
            .clipShape(Capsule()) // Garante que a ZStack toda tem a forma de cápsula
        }
        .frame(height: 8) // Define a altura da GeometryReader
    }
}


struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            //0 of 3
            ProgressBarView(current: 0, total: 3)
            
            //2 of 3
            ProgressBarView(current: 2, total: 3)
            
            //3 of 3
            ProgressBarView(current: 3, total: 3)
        }
        .padding()
    }
}
