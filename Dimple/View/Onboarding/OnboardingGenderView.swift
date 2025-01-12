//
//  OnboardingGenderView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingGenderView: View {
    
    @Bindable var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            CustomSelectionButton(text: Gender.male.title, isSelected: .constant(viewModel.user.gender == .male))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .offset(x: viewModel.user.gender == .female && isAnimating ? -UIScreen.main.bounds.width : 0)
                .onTapGesture {
                    viewModel.user.gender = .male
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        viewModel.step = .age
                    }
                }
            
            CustomSelectionButton(text: Gender.female.title, isSelected: .constant(viewModel.user.gender == .female))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .offset(x: viewModel.user.gender == .male && isAnimating ? -UIScreen.main.bounds.width : 0)
                .onTapGesture {
                    viewModel.user.gender = .female
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        viewModel.user.gender = User.Gender.female.rawValue
                        viewModel.step = .age
                    }
                }
        }
        .padding(.vertical)
        .padding(.bottom)
        .onboardingTemplate(title: "CHOOSE GENDER YOU\nIDENTIFY WITH", progress: 0.30)
        .onDisappear {
            isAnimating = false
        }
    }
}



#Preview {
    OnboardingGenderView(viewModel: .init())
}
