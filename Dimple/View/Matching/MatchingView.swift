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
    
    @State private var path: [NavigationPath] = []
    
    enum NavigationPath {
        case commentView
    }
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            ZStack(alignment: .center) {
                
                if isFetchingProfiles {
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                    
                } else {
                    
                    ForEach(viewModel.profiles) { profile in
                        ProfileView(profileViewModel: ProfileViewModel(profile: profile), likeTapHandler: self.likeProfileHandler)
                    }
                    
                }
                
            }
            .navigationDestination(for: NavigationPath.self) { path in
                switch path {
                case .commentView:
                    LikeCommentView(profile: self.viewModel.selectedProfile!, commentPhotoId: self.viewModel.commentPhotoId, commentFlavorId: self.viewModel.commentFlavorId)
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
    
    func likeProfileHandler(profile: Profile, photoId: Int?, flavorId: Int?) {
        self.viewModel.selectedProfile = profile
        self.viewModel.commentPhotoId = photoId
        self.viewModel.commentFlavorId = flavorId
        self.path = [.commentView]
    }
    
}


#Preview {
    MatchingView(viewModel: .init())
}
