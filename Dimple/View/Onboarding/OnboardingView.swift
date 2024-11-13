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
    
    @Environment(\.dismiss) var dismiss
    
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
        .sheet(isPresented: $viewModel.isPhotoPickerPresented) {
            
            #warning("refactor")
            let replacePhoto = viewModel.photos.first(where: {$0.index == viewModel.selectedPhotoIndex})?.photo != nil
            
            let photosLimit = replacePhoto ? 1 : 6
            
            
            let spotsTaken = replacePhoto ? 0 : (viewModel.photos.last(where: {$0.photo != nil})?.index ?? 0)
            
            let finalSpots = spotsTaken == 0 ? 0 : spotsTaken + 1
           
            PhotoPickerView(selectionLimit: photosLimit - finalSpots) { selectedPhotos in
                
                if replacePhoto, let newPhoto = selectedPhotos.first {
                    viewModel.photos[viewModel.selectedPhotoIndex].photo = Image(uiImage: newPhoto)
                    viewModel.photos[viewModel.selectedPhotoIndex].uiPhoto = newPhoto
                    return
                }
                
                guard var index = viewModel.photos.first(where: {$0.photo == nil})?.index else {
                    return
                }
                
                selectedPhotos.forEach { photo in
                    viewModel.photos[index].photo = Image(uiImage: photo)
                    viewModel.photos[index].uiPhoto = photo
                    index += 1
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
            
            dismiss()
            return
        }
        
        viewModel.step = OnboardingStep.allCases[currentIndex - 1]
    }
    
}


@Observable
class OnboardingViewModel {
    
    var photos: [GalleryPhoto] = [.init(index: 0), .init(index: 1), .init(index: 2), .init(index: 3), .init(index: 4), .init(index: 5)]
    
    var selectedPhotoIndex: Int = 0
    
    var step: OnboardingStep = .profile
    
    var user: User = .init()
    
    var showMainView: Bool = false
    
    var isPhotoPickerPresented: Bool = false
    
    func checkEmailAddress() {
        
        
        
    }
    
    func saveUserPreferences() async {
        
        let data: [String: Any] = [
            "gender": user.interestedIn!.rawValue
        ]
        
        do {
            let (data, response) = try await NetworkManager.shared.fetchResponse(
                urlString: "https://api.dimple.dating/v1/user/preference",
                method: .POST,
                body: data
            )
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code:", httpResponse.statusCode)
                print("Headers:", httpResponse.allHeaderFields)
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("JSON Response:", jsonObject)
            } catch {
                print("Failed to parse JSON:", error)
            }
            
        } catch {
            print("Request failed with error:", error)
        }
        
    }
    
    func saveUserData() async {
        
        let data: [String: Any] = [
            "firstname": user.name,
            "lastname": user.lastName,
            "age": user.age,
            "tall": user.height,
            "gender": user.gender!.rawValue
        ]
        
        do {
            let (data, response) = try await NetworkManager.shared.fetchResponse(
                urlString: "https://api.dimple.dating/v1/user/update",
                method: .PUT,
                body: data
            )
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code:", httpResponse.statusCode)
                print("Headers:", httpResponse.allHeaderFields)
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print("JSON Response:", jsonObject)
            } catch {
                print("Failed to parse JSON:", error)
            }
            
        } catch {
            print("Request failed with error:", error)
        }
        
        
    }
    
    func saveUserPhoto(_ photo: UIImage) async {
        
        do {
            let (data, response) = try await NetworkManager.shared.uploadPhoto(image: photo)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

#Preview {
    OnboardingView()
}
