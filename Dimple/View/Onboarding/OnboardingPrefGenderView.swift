//
//  OnboardingPrefGenderView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingPrefGenderView: View {
    
    @Bindable var viewModel: OnboardingViewModel
    @State private var isAnimating = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Spacer()
            
            CustomSelectionButton(text: InterestedInGender.men.title, isSelected: .constant(viewModel.user.interestedIn == .men))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .offset(x: viewModel.user.interestedIn != .men && isAnimating ? -UIScreen.main.bounds.width : 0)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.user.interestedIn = .men
                        isAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        savePreferences(value: .men)
                    }
                }
            
            CustomSelectionButton(text: InterestedInGender.women.title, isSelected: .constant(viewModel.user.interestedIn == .women))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .offset(x: viewModel.user.interestedIn != .women && isAnimating ? -UIScreen.main.bounds.width : 0)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.user.interestedIn = .women
                        isAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        savePreferences(value: .women)
                    }
                }
            
            CustomSelectionButton(text: InterestedInGender.openToAll.title, isSelected: .constant(viewModel.user.interestedIn == .openToAll))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .offset(x: viewModel.user.interestedIn != .openToAll && isAnimating ? -UIScreen.main.bounds.width : 0)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.user.interestedIn = .openToAll
                        isAnimating = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        savePreferences(value: .openToAll)
                    }
                }
            
        }
        .padding(.vertical)
        .padding(.bottom)
        .onboardingTemplate(title: "CHOOSE GENDER YOU ARE\nINTERESTED IN", progress: 0.6)
        .onDisappear {
            isAnimating = false
        }
        
    }
    
    func savePreferences(value: InterestedInGender) {
        
        viewModel.step = .height
        
        Task.detached {
            await viewModel.saveUserPreferences()
        }
//        
        
    }

}

#Preview {
    OnboardingPrefGenderView(viewModel: .init())
}

