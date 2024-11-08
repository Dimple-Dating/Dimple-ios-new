//
//  OnboardingAgeView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingAgeView: View {
    
    @Binding var onboardingStep: OnboardingStep
    
    @State private var activeID: UUID?
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Spacer()
            
            Spacer()
            
            Spacer()
            CustomCarousel(
                selection: $activeID,
                data: ageValues
            ) { age in
                GeometryReader { _ in
                    Text("\(age.value)")
                        .font(.system(size: 72))
                }
            }
            .frame(height: 72)
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: "Both")
            
            Spacer()
            
            OnboardingActionButton() {
                onboardingStep = .prefGender
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
            
        }
        .padding(.vertical)
        .onboardingTemplate(title: "SET YOUR AGE", progress: 0.45)
        
    }

}

#Preview {
    OnboardingAgeView(onboardingStep: .constant(.age))
}
