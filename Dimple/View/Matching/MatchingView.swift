//
//  MatchingView.swift
//  Dimple
//
//  Created by Adrian Topka on 15/11/2024.
//

import SwiftUI
import Observation

struct MatchingView: View {
    
    @Bindable var viewModel: MatchingViewModel
    
    @State private var isFetchingProfiles: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .center) {
            
            if isFetchingProfiles {
                
                ProgressView()
                    .progressViewStyle(.circular)
                
            } else {
                
                ForEach(viewModel.profiles) { profile in
                    ProfileView(profile: profile)
                }
                
            }
            
        }
        .onAppear {
            Task {
                if viewModel.profiles.isEmpty {
                    self.isFetchingProfiles = true
                    await viewModel.fetchUsers()
                    self.isFetchingProfiles = false
                }
            }
        }
    
    }
    
}

#Preview {
    MatchingView(viewModel: .init())
}
