//
//  OnboardingActionButton.swift
//  Dimple
//
//  Created by Adrian Topka on 21/08/2024.
//

import SwiftUI

struct OnboardingActionButton: View {
    
    var title: String = "continue"
    
    var action: () -> ()
    
    @State private var animationOffset: CGFloat = -22
    
    var body: some View {
        
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                animationOffset = -60
            } completion: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    animationOffset = -18
                } completion: {
                    action()
                }
            }
            
        }, label: {
            
            ZStack(alignment: .trailing) {
                
                Circle()
                    .frame(width: 50)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                
                HStack {
                    Text(title.uppercased())
                        .font(.avenir(style: .regular, size: 18))
                        .tracking(1)
                    
                    Image(.longRightArrow)
                }
                .tint(.black)
                .offset(x: animationOffset)
            }
            
        })
        
    }
    
}

#Preview {
    OnboardingActionButton(action: {})
}
