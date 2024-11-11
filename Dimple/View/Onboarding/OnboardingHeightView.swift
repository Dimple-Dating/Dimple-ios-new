//
//  OnboardingHeightView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingHeightView: View {
    
    @State private var  heightValues: [CarouselModel] = []
    
    @Binding var viewModel: OnboardingViewModel
    
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
                        .font(.avenir(style: .medium, size: 64))
                }
            }
            .frame(height: 72)
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: "Both")
            
            Spacer()
            
            OnboardingActionButton() {
                
                if let selectedHeight = heightValues.first(where: {$0.id == activeID})?.value {
                    
                    viewModel.user.height = selectedHeight.convertToMeters()
                    viewModel.step = .gallery
                    
                }
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
            .padding(.bottom, 54)
            
        }
        .onboardingTemplate(title: "HOW TALL ARE YOU?", progress: 0.75)
        .onAppear {
            setHeights()
        }
        
    }
    
    func setHeights() {
        
        for feet in 4...7 {
            for inch in 0...11 {
                let item = CarouselModel(value: "\(feet)’\(inch)")
                heightValues.append(item)
            }
        }
        
        self.activeID = heightValues.first(where: {$0.value == "5’6"})?.id
    }

}

#Preview {
    OnboardingHeightView(viewModel: .constant(.init()))
}
