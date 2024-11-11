//
//  OnboardingView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI
import Observation

enum OnboardingStep: String, CaseIterable {
    case profile
    case gender
    case age
    case prefGender
    case height
    case gallery
    case locationPermission
    case rate
    case final
  
}

struct OnboardingView: View {
    
    @State private var viewModel: OnboardingViewModel = .init()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Button {
                previousStep()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.black)
            }
            .hSpacing(.leading)
            .padding(.leading, 32)
            .padding(.bottom)

            
            Divider()
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        
                        OnboardingProfileView(viewModel: $viewModel)
                            .id(OnboardingStep.profile)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingGenderView(viewModel: $viewModel)
                            .id(OnboardingStep.gender)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingAgeView(viewModel: $viewModel)
                            .id(OnboardingStep.age)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingPrefGenderView(viewModel: $viewModel)
                            .id(OnboardingStep.prefGender)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingHeightView(viewModel: $viewModel)
                            .id(OnboardingStep.height)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingGalleryView(viewModel: $viewModel)
                            .id(OnboardingStep.gallery)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingLocationView(viewModel: $viewModel)
                            .id(OnboardingStep.locationPermission)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingRateView(viewModel: $viewModel)
                            .id(OnboardingStep.rate)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                        OnboardingFinalView(viewModel: $viewModel)
                            .id(OnboardingStep.final)
                            .frame(width: UIScreen.main.bounds.width)
                            .containerRelativeFrame(.horizontal)
                        
                    }
                }
                
                .ignoresSafeArea()
                .scrollDisabled(true)
                .onChange(of: viewModel.step) {
                    withAnimation {
                        proxy.scrollTo(viewModel.step, anchor: .center)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showMainView, content: {
            MainTabbarView()
        })
    }
    
    private func previousStep() {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: viewModel.step),
              currentIndex > 0 else {
            return
        }
        viewModel.step = OnboardingStep.allCases[currentIndex - 1]
    }
    
}


@Observable
class OnboardingViewModel {
    
    var step: OnboardingStep = .profile
    
    var user: User = .init()
    
    var showMainView: Bool = false
    
    
}

#Preview {
    OnboardingView()
}
