//
//  OnboardingFinalView.swift
//  Dimple
//
//  Created by Adrian Topka on 11/11/2024.
//

import SwiftUI


struct OnboardingFinalView: View {
    
    @AppStorage("onboardingFinished") var onboardingFinished: Bool = false
    
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Spacer()
            
            Text("YOU DID IT!")
                .font(.avenir(style: .medium, size: 32))
                .padding(.bottom)
                .padding(.horizontal, 24)
            
            Text("Thanks for putting yourself out into the world of self-care. Our mission to spread love, tolerance and self-acceptance began with you. To edit more details about your individuality visit Profile and pick your flavors for personalized reachability!\n\nOh, and don't forget to post stories! We would (literally) love to see your dog's pictures on a daily basis!")
                .font(.avenir(style: .regular, size: 16))
                .lineSpacing(3)
                .padding(.trailing, 28)
                .padding(.horizontal, 24)
            
            Spacer()
            
            HStack(spacing: 0) {
                
                Button {
                    onboardingFinished = true
                } label: {
                    
                    Text("Go to profile")
                        .frame(maxWidth: .infinity, maxHeight: 90)
                        .padding(.bottom)
                    
                }
                
                Button {
                    onboardingFinished = true
                } label: {
                    Text("Discover people")
                        .frame(maxWidth: .infinity, maxHeight: 90)
                        .padding(.bottom)
                }

            }
            .font(.avenir(style: .regular, size: 15))
            .foregroundStyle(.white)
            .background(.black)

        }
        .onAppear {
            Task.detached {
                await viewModel.saveUserData()
            }
        }
    }
}

#Preview {
    OnboardingFinalView(viewModel: .init())
}
