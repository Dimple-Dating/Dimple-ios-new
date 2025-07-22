//
//  MatchingView.swift
//  Dimple
//
//  Created by Adrian Topka on 15/11/2024.
//

import Lottie
import SwiftUI
import Observation

struct TestView: View {
    
    var body: some View {
        
        VStack {
            
            LottieView(animation: .named("searching.json"))
            
        }
        
    }
}

struct MatchingView: View {
    
    @Bindable var viewModel: MatchingViewModel
    
    @State private var isFetchingProfiles: Bool = false
    
    @State private var path: [NavigationPath] = []
    @State private var showMoreDialog: Bool = false
    
    enum NavigationPath {
        case commentView
        case reportView
    }
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            ZStack(alignment: .center) {
                
                if isFetchingProfiles {
                    
                    LottieView(animation: .named("searching.json"))
                        .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                        .frame(width: 90)
                    
                    
                } else {
                    
                    ForEach(Array(viewModel.topProfiles().enumerated()), id: \.element.id) { offset, profile in
                        ProfileView(
                            profileViewModel: ProfileViewModel(profile: profile),
                            likeTapHandler: self.likeProfileHandler,
                            dismissProfileHandler: self.dismissProfileHandler,
                            undoTapHandler: self.undoTapHandler,
                            moreTapHandler: self.moreTapHander
                        )
                        .zIndex(Double(viewModel.profiles.count - (viewModel.currentIndex + offset)))
                    }
                    
                }
                
            }
            .confirmationDialog("", isPresented: $showMoreDialog, titleVisibility: .hidden) {
                Button("Report profile") {
                    self.path = [.reportView]
                }
                
                Button("Block & Report profile") {
                    self.path = [.reportView]
                }
                
                Button("Cancel", role: .cancel) { }
            }
            .tint(.black)
            .navigationDestination(for: NavigationPath.self) { path in
                switch path {
                case .commentView:
                    LikeCommentView(profile: self.viewModel.selectedProfile!, commentPhotoId: self.viewModel.commentPhotoId, commentFlavorId: self.viewModel.commentFlavorId)
                case .reportView:
                    Text("Report view")
                        .toolbar(.hidden, for: .tabBar)
                    
                
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
    
    func dismissProfileHandler(profile: Profile) {
        // Save last NO index and advance currentIndex
        viewModel.lastNoIndex = viewModel.currentIndex
        viewModel.currentIndex += 1
    }
    
    func undoTapHandler() {
        viewModel.undoLastSwipe()
    }
    
    func moreTapHander() {
        showMoreDialog = true
    }
    
}


#Preview {
    TestView()
}
