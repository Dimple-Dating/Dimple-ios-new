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
    
    @Binding var viewModel: OnboardingViewModel
    
    @State private var showRequiredNameField: Bool = false
    
    @State private var showRequiredEmailField: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            CustomTextField(placeholder: "Your Name", value: $viewModel.user.name, showIsRequired: $showRequiredNameField)
            
            CustomTextField(placeholder: "Your Last Name (optional)", value: $viewModel.user.lastName, showIsRequired: .constant(false))
            
            CustomTextField(placeholder: "Your Email Address", value: $viewModel.user.email, showIsRequired: $showRequiredEmailField)
            
            CustomTextField(placeholder: "Your Nickname", value: $viewModel.user.userName, showIsRequired: .constant(false))
            
            Spacer()
            
            OnboardingActionButton() {
                
                if viewModel.user.name.isEmpty {
                    showRequiredNameField = true
                } else if viewModel.user.email.isEmpty {
                    showRequiredEmailField = true
                } else {
                    viewModel.step = .gender
                }
            }
            .hSpacing(.trailing)
            .padding(.bottom, 54)
            
        }
        .padding(.horizontal)
        .padding(.horizontal)
        .onboardingTemplate(title: "COMPLETE YOUR PROFILE", progress: 0.15)
        
    }

}

#Preview {
    
    OnboardingView()
    
}
