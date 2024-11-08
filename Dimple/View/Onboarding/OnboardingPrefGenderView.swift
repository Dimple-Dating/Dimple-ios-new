//
//  OnboardingPrefGenderView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingPrefGenderView: View {
    
    @Binding var onboardingStep: OnboardingStep
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Spacer()
            
            CustomSelectionButton(text: "Men", isSelected: .constant(false))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .onTapGesture {
                    onboardingStep = .height
                }
            
            CustomSelectionButton(text: "Women", isSelected: .constant(false))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .onTapGesture {
                    onboardingStep = .height
                }
            
            CustomSelectionButton(text: "Open to all", isSelected: .constant(false))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .onTapGesture {
                    onboardingStep = .height
                }
            
        }
        .padding(.vertical)
        .onboardingTemplate(title: "CHOOSE GENDER YOU ARE\nINTERESTED IN", progress: 0.6)
        
    }

}

#Preview {
    OnboardingPrefGenderView(onboardingStep: .constant(.age))
}

