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
            let (data, _) = try await NetworkManager.shared.request(.getUserList, queryParameters: data, method: .GET)
            let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            print(json)
            let responseData = try JSONDecoder().decode(ProfilesResponse.self, from: data)
            
            // Append new users to existing array
            self.profiles.append(contentsOf: responseData.users)
            
        } catch {
            print("Request failed with error:", error)
            // Handle error appropriately
        }
        
    }
}

// Add this structure to handle the API response
private struct ProfilesResponse: Decodable {
    let users: [Profile]
}
