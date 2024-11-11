//
//  OnboardingTemplate.swift
//  Dimple
//
//  Created by Adrian Topka on 11/11/2024.
//

import SwiftUI


struct OnboardingTemplate: ViewModifier {
    
    let title: String
    let progress: Float

    func body(content: Content) -> some View {
        
        VStack(spacing: 0) {
            
            Text(title)
                .font(.avenir(style: .demiBold, size: 20))
                .tracking(0.7)
                .hSpacing(.leading)
                .padding([.leading, .all])
                .padding(.leading)
            
            ProgressView(value: progress)
                .tint(.black)
                .progressViewStyle(LinearProgressViewStyle())
                .padding([.bottom, .leading])
                .padding(.leading)
            
            content
            
        }
        .padding(.vertical)
        
    }
}

extension View {
    func onboardingTemplate(title: String, progress: Float) -> some View {
        modifier(OnboardingTemplate(title: title, progress: progress))
    }
}
