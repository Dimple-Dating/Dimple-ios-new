//
//  OnboardingViewModel.swift
//  Dimple
//
//  Created by Adrian Topka on 09/01/2025.
//

import SwiftUI


@Observable
class OnboardingViewModel {
    
    var photos: [GalleryPhoto] = [.init(index: 0), .init(index: 1), .init(index: 2), .init(index: 3), .init(index: 4), .init(index: 5)]
    
    var selectedPhotoIndex: Int = 0
    
    var step: OnboardingStep = .profile
    
    var user: OnboardingUser = .init()
    
    var showMainView: Bool = false
    
    var isPhotoPickerPresented: Bool = false
    
    var isSchoolSearchViewPresented: Bool = false
    
    var schoolsManager: SearchSchoolViewModel = .init()
    
    var locationManager = LocationManager()
    
    func checkEmailAddress() {
        
        
        
    }
    
    func saveUserPreferences() async {
        
        let data: [String: Any] = [
            "min_age": 18,
            "max_age": 40,
            "distance": 100,
            "min_height": 121.92,
            "max_height": 213.36,
            "gender": user.interestedIn!.rawValue
        ]
        
        do {
            let (data, response) = try await NetworkManager.shared.request(.createPreference, method: .POST, body: data)
            
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
        
        let identifier = await UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let data: [String: Any] = [
            "email": user.email,
            "firstname": user.name,
            "lastname": user.lastName,
            "age": user.age,
            "tall": user.height,
            "gender": user.gender!.rawValue,
            "onboarding_finished": "true",
            "device_identifier": identifier,
            "lat": user.latitude ?? 40.730610,
            "lng": user.longitude ?? -73.935242
        ]
        
        do {
            
            let (data, response) = try await NetworkManager.shared.request(.updateUser, method: .PUT, body: data)
            
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
    
    func saveUserPhoto(_ photo: UIImage, photoOrder: Int) async {
        
        do {
            let (data, response) = try await NetworkManager.shared.uploadPhoto(image: photo, photoOrder: photoOrder)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}
