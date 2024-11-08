//
//  OnboardingView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

enum OnboardingStep: String, CaseIterable {
    case profile
    case gender
    case age
    case prefGender
    case height
    case gallery
    
    var progress: Float {
        switch self {
        case .profile:
            return 0.15
        case .gender:
            return 0.30
        case .age:
            return 0.35
        case .prefGender:
            return 0.50
        case .height:
            return 0.65
        case .gallery:
            return 0.75
        }
    }
    
    var title: String {
        switch self {
        case .profile:
            return "COMPLETE YOUR PROFILE"
        case .gender:
            return "CHOOSE GENDER YOU\nIDENTIFY WITH"
        case .age:
            return "SET YOUR AGE"
        case .prefGender:
            return "CHOOSE GENDER YOU ARE\nINTERESTED IN"
        case .height:
            return "HOW TALL ARE YOU?"
        case .gallery:
            return "COMPLETE YOUR PROFILE"
        }
    }
}

struct OnboardingView: View {
    
    @AppStorage("logged") var loggedIn: Bool = false
    
    @State private var onboardingStep: OnboardingStep = .profile
    
    var body: some View {
        
        VStack {
            
            Button {
                previousStep()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.black)
            }
            .hSpacing(.leading)
            .padding(.leading, 32)
            .padding(.bottom, 8)

            
            Divider()
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        OnboardingProfileView(onboardingStep: $onboardingStep)
                            .id(OnboardingStep.profile)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingGenderView(onboardingStep: $onboardingStep)
                            .id(OnboardingStep.gender)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingAgeView(onboardingStep: $onboardingStep)
                            .id(OnboardingStep.age)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingPrefGenderView(onboardingStep: $onboardingStep)
                            .id(OnboardingStep.prefGender)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingHeightView(onboardingStep: $onboardingStep)
                            .id(OnboardingStep.height)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingGalleryView(onboardingStep: $onboardingStep)
                            .id(OnboardingStep.gallery)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                    }
                }
                .scrollDisabled(true)
                .onChange(of: onboardingStep) {
                    withAnimation {
                        proxy.scrollTo(onboardingStep, anchor: .center)
                    }
                }
            }
        }
    }
    
    private func previousStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: onboardingStep),
              currentIndex > 0 else {
            return
        }
        onboardingStep = OnboardingStep.allCases[currentIndex - 1]
    }
    
}


#Preview {
    OnboardingView()
}
