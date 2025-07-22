//
//  MatchingViewModel.swift
//  Dimple
//
//  Created by Adrian Topka on 09/01/2025.
//

import SwiftUI

@Observable
class MatchingViewModel {
    
    var profiles: [Profile] = []
    
    // Index of the currently visible/top profile
    var currentIndex: Int = 0
    
    // For undo support (only last NO)
    var lastNoIndex: Int? = nil
    
    var selectedProfile: Profile? = nil
    var commentPhotoId: Int? = nil
    var commentFlavorId: Int? = nil
    
    var fetchPage: Int = 1
    
    func fetchUsers(isVideochatSwipeMode: Bool = false) async {
        
        let data: [String: Any] = [
            "page" : fetchPage,
            "recordsPerPage" : 30
        ]
        
        do {
            let (rawData, _) = try await NetworkManager.shared.request(.getUserList, queryParameters: data, method: .GET)
            
            guard
                let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String: Any],
                let usersArray = json["users"] as? [[String: Any]]
            else {
                self.profiles = []
                return
            }
            print(usersArray)
            let newProfiles: [Profile] = usersArray.compactMap { userDict in
                guard let singleUserData = try? JSONSerialization.data(withJSONObject: userDict, options: []) else {
                    return nil
                }
                return try? JSONDecoder().decode(Profile.self, from: singleUserData)
            }
            
            self.profiles = newProfiles
            
        } catch {
            print("Request failed with error:", error.localizedDescription)
        }
        
    }
    
    func undoLastSwipe() {
        guard let idx = lastNoIndex else { return }
        currentIndex = idx
        lastNoIndex = nil
    }
    
    func topProfiles() -> ArraySlice<Profile> {
        // Return from currentIndex to end
        return profiles[currentIndex..<profiles.count]
    }
    
}

// Add this structure to handle the API response
private struct ProfilesResponse: Decodable {
    let users: [Profile]
}
