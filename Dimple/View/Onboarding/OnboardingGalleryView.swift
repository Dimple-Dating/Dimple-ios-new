//
//  OnboardingGalleryView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingGalleryView: View {
    
    @Binding var onboardingStep: OnboardingStep
    
    var body: some View {
        
        VStack {
            
            Text("Tap to add, drag & drop to change the order.")
            
            Spacer()
            
            OnboardingActionButton() {
                
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
        }
        .onboardingTemplate(title: "COMPLETE YOUR PROFILE", progress: 1.0)
        
    }
}

#Preview {
    OnboardingGalleryView(onboardingStep: .constant(.gender))
}
