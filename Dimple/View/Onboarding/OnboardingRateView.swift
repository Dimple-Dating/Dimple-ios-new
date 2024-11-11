//
//  OnboardingRateView.swift
//  Dimple
//
//  Created by Adrian Topka on 11/11/2024.
//

import SwiftUI

struct OnboardingRateView: View {
    
    @Binding var viewModel: OnboardingViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Spacer()
            
            Text("YOU DID IT!")
                .font(.avenir(style: .medium, size: 32))
                .padding(.bottom)
                .padding(.leading, 24)
            
            Text("We greatly appreciate your true support of Dimple 🙏🏻. Please show us the best Dimple ❤️ and rate us NOW for really good karma 🌟.")
                .font(.avenir(style: .regular, size: 16))
                .lineSpacing(3)
                .padding(.trailing, 25)
                .padding(.leading, 24)
            
            
            Spacer()
            
            HStack(spacing: 0) {
                
                Button {
                    // rate
                } label: {
                    
                    Text("Rate")
                        .frame(maxWidth: .infinity, maxHeight: 90)
                        .padding(.bottom)
                    
                }
                
                Button {
                    viewModel.step = .final
                } label: {
                    Text("Skip")
                        .frame(maxWidth: .infinity, maxHeight: 90)
                        .padding(.bottom)
                }

            }
            .font(.avenir(style: .regular, size: 15))
            .foregroundStyle(.white)
            .background(.black)
            
        }
        
    }
}

#Preview {
    OnboardingRateView(viewModel: .constant(.init()))
}