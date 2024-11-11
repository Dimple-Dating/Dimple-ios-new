//
//  OnboardingGenderView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingGenderView: View {
    
    @Binding var viewModel: OnboardingViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Spacer()
            
            CustomSelectionButton(text: User.Gender.male.title, isSelected: .constant(false))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .onTapGesture {
                    viewModel.user.gender = User.Gender.male.rawValue
                    viewModel.step = .age
                }
            
            CustomSelectionButton(text: User.Gender.female.title, isSelected: .constant(false))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .onTapGesture {
                    viewModel.user.gender = User.Gender.female.rawValue
                    viewModel.step = .age
                }
            
        }
        .padding(.vertical)
        .padding(.bottom)
        .onboardingTemplate(title: "CHOOSE GENDER YOU\nIDENTIFY WITH", progress: 0.30)
        
    }

}

#Preview {
    OnboardingGenderView(viewModel: .constant(.init()))
}
