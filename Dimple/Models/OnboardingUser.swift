//
//  OnboardingUser.swift
//  Dimple
//
//  Created by Adrian Topka on 11/11/2024.
//

import Foundation

struct OnboardingUser: Identifiable {
    
    var id = UUID().uuidString
    var name: String = ""
    var lastName: String = ""
    var email: String = ""
    var userName: String = ""
    var gender: Gender? = nil
    var age: String = ""
    var interestedIn: InterestedInGender? = nil
    var height: Float = 0
    var latitude: Double?
    var longitude: Double?
    
}

extension Encodable {
    func toDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonObject as? [String: Any]
        } catch {
            print("Failed to convert struct to [String: Any]:", error)
            return nil
        }
    }
}
