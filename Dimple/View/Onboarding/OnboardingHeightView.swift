//
//  OnboardingHeightView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingHeightView: View {
    
    @Binding var onboardingStep: OnboardingStep
    
    @State private var activeID: UUID?
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Spacer()
            
            Spacer()
            
            Spacer()
            CustomCarousel(
                selection: $activeID,
                data: heightValues
            ) { height in
                GeometryReader { _ in
                    Text("\(height.value)")
                        .font(.system(size: 72))
                }
            }
            .frame(height: 72)
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: "Both")
            
            Spacer()
            
            OnboardingActionButton() {
                onboardingStep = .gallery
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
            
        }
        .padding(.vertical)
        .onboardingTemplate(title: "HOW TALL ARE YOU?", progress: 0.75)
        
    }

}

#Preview {
    OnboardingHeightView(onboardingStep: .constant(.age))
}
