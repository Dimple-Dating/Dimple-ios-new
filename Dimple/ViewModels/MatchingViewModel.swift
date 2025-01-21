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
    
    var selectedProfile: Profile? = nil
    var commentPhotoId: Int? = nil
    var commentFlavorId: Int? = nil
    
    var fetchPage: Int = 1
    
    init() {
        print("robie init")
    }

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
    
}

// Add this structure to handle the API response
private struct ProfilesResponse: Decodable {
    let users: [Profile]
}
