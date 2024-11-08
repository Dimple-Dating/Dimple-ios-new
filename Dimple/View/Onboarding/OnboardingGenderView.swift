//
//  OnboardingGenderView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingGenderView: View {
    
    @Binding var onboardingStep: OnboardingStep
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Spacer()
            
            CustomSelectionButton(text: "Male", isSelected: .constant(false))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .onTapGesture {
                    onboardingStep = .age
                }
            
            CustomSelectionButton(text: "Female", isSelected: .constant(false))
                .hSpacing(.trailing)
                .padding(.trailing, 32)
                .onTapGesture {
                    onboardingStep = .age
                }
            
        }
        .padding(.vertical)
        .onboardingTemplate(title: "CHOOSE GENDER YOU\nIDENTIFY WITH", progress: 0.30)
        
    }

}

#Preview {
    OnboardingGenderView(onboardingStep: .constant(.age))
}
