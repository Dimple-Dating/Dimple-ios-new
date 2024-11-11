//
//  OnboardingAgeView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingAgeView: View {
    
    @Binding var viewModel: OnboardingViewModel
    
    @State private var activeID: UUID?
    
    
    let ageValues: [CarouselModel] = (18...99).compactMap({ CarouselModel(value: "\($0)") })

    
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
                        .font(.avenir(style: .medium, size: 64))
                }
            }
            .frame(height: 72)
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: "Both")
            
            Spacer()
            
            OnboardingActionButton() {
                
                if let selectedAge = ageValues.first(where: {$0.id == activeID})?.value {
                    viewModel.user.age = selectedAge
                    viewModel.step = .prefGender
                }
                
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
            .padding(.bottom, 54)
            
        }
        .onboardingTemplate(title: "SET YOUR AGE", progress: 0.45)
        .onAppear {
            activeID = ageValues[5].id
        }
        
    }

}

#Preview {
    OnboardingAgeView(viewModel: .constant(.init()))
}
