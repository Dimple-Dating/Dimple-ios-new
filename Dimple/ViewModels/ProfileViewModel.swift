//
//  ProfileViewModel.swift
//  Dimple
//
//  Created by Adrian Topka on 21/01/2025.
//

import Foundation

@Observable
class ProfileViewModel {
    
    let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    func likeProfile() async {
        
        let body = ["profileId" : profile.id]
        
        do {
            let (rawData, _) = try await NetworkManager.shared.request(.likeProfile, method: .POST, body: body)
            
            if let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String: Any],
               let conversationID = json["conversation_id"] as? [[String: Any]] {
                // JEŚLI BEDZIE CONVERSATIONID TZN. ŻE JEST MATCH - Trzeba obsłużyć
            }
            
        } catch {
            print("Request failed with error:", error.localizedDescription)
        }
        
    }
    
    func doNotLikeProfile() async {
        
        do {
            let _ = try await NetworkManager.shared.request(.dismissSwipeUser(userID: profile.id), method: .POST)
            // OBSLUGA BLEDU
        } catch {
            
        }
    }
    
    static func likePhoto(_ photoId: String) async {
        
        do {
            let (rawData, _) = try await NetworkManager.shared.request(.likePhoto(photoId: photoId), method: .POST)
            
            if let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String: Any],
               let conversationID = json["conversation_id"] as? [[String: Any]] {
                // JEŚLI BEDZIE CONVERSATIONID TZN. ŻE JEST MATCH - Trzeba obsłużyć
            }
            
        } catch {
            
        }
        
    }
    
}
