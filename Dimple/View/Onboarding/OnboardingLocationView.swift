//
//  OnboardingLocationView.swift
//  Dimple
//
//  Created by Adrian Topka on 11/11/2024.
//

import SwiftUI

struct OnboardingLocationView: View {
    
    @Binding var viewModel: OnboardingViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Spacer()
            
            Text("ENABLE\nLOCATION")
                .font(.avenir(style: .medium, size: 32))
                .padding(.bottom)
            
            Text("Enable your location in order to use Dimple.\nIt will be used to show potential matches near you.\n\nWant to meet other Dimplers? Use our Passport option to discover the kindest community nation wide.")
                .font(.avenir(style: .regular, size: 14))
                .lineSpacing(3)
                .padding(.trailing, 48)
            
            Spacer()
            
            Spacer()
            
            OnboardingActionButton(title: "allow location") {
                viewModel.step = .rate
            }
            .hSpacing(.trailing)
            .padding(.bottom, 32)
            
        }
        .padding(32)
        
    }
    
}

#Preview {
    OnboardingLocationView(viewModel: .constant(.init()))
}
