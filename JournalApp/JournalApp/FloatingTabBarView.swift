//
//  FloatingTabBarView.swift
//  JournalApp
//
//  Created by Nil Silva on 19/12/2025.
//

import SwiftUI

struct FloatingTabBarView: View {
    @Binding var selectedTab: Tab
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        selectedTab = tab
                    }
                }) {
                    ZStack {
                        let iconName = selectedTab == tab ? getFilledIconName(for: tab) : tab.rawValue

                        if selectedTab == tab {
                            Circle()
                                .fill(Color("AppAccent").opacity(0.15))
                                .matchedGeometryEffect(id: "ActiveTabCircle", in: animation)
                                .frame(width: 50, height: 50)
                        }
                        
                        Image(iconName)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(selectedTab == tab ? Color("AppAccent") : .gray.opacity(0.5))
                        
                    }
                    .frame(width: 50, height: 50)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    
    private func getFilledIconName(for tab: Tab) -> String {
        switch tab {
        case .habits:
            return "list"
        case .home:
            return "Home"
        case .goals:
            return "goal"
        }
    }
}

#Preview {
    ZStack {
        Color(UIColor.systemGray4)
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            FloatingTabBarView(selectedTab: .constant(.home))
                .padding(.bottom, 20)
        }
    }
}
