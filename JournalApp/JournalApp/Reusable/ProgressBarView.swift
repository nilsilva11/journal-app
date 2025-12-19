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
        if total == 0 { return 0 } 
        return current / total
    }
    
    var body: some View {
        
        
        GeometryReader { proxy in

            ZStack(alignment: .leading) {
                
                Capsule()
                    .fill(Color("LightBar"))
                    .frame(height: 8)
                
                Capsule()
                    .fill(Color("AppAccent"))
                    .frame(width: proxy.size.width * self.progress, height: 8)
            }
            .clipShape(Capsule())
        }
        .frame(height: 8)
    }
}


struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            
            ProgressBarView(current: 0, total: 3)
            ProgressBarView(current: 2, total: 3)
            ProgressBarView(current: 3, total: 3)
        }
        .padding()
    }
}
