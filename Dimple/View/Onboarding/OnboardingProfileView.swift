//
//  OnboardingProfileView.swift
//  Dimple
//
//  Created by Adrian on 20/08/2024.
//

import SwiftUI


struct OnboardingProfileView: View {
    
    @State private var nameValue: String = ""
    
    @State private var progressValue: Float = 0.25
    
    @Binding var onboardingStep: OnboardingStep
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            CustomTextField(placeholder: "Your Name", value: $nameValue, showIsRequired: .constant(false))
            
            CustomTextField(placeholder: "Your Last Name (optional)", value: $nameValue, showIsRequired: .constant(false))
            
            CustomTextField(placeholder: "Your Email Address", value: $nameValue, showIsRequired: .constant(false))
            
            CustomTextField(placeholder: "Your Nickname", value: $nameValue, showIsRequired: .constant(false))
            
            Spacer()
            
            OnboardingActionButton() {
                onboardingStep = .gender
            }
            .hSpacing(.trailing)
            
        }
        .padding(.horizontal)
        .padding(.horizontal)
        .onboardingTemplate(title: "COMPLETE YOUR PROFILE", progress: 0.15)
        
    }

}

#Preview {
    
    OnboardingProfileView(onboardingStep: .constant(.age))
    
}


struct OnboardingTemplate: ViewModifier {
    
    let title: String
    let progress: Float

    func body(content: Content) -> some View {
        
        VStack(spacing: 0) {
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
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
