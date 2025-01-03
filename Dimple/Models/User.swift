//
//  User.swift
//  Dimple
//
//  Created by Adrian Topka on 11/11/2024.
//

import Foundation

struct User: Identifiable {
    
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
    
    enum Gender: Int {
        case male = 2
        case female = 3
        
        var title: String {
            switch self {
            case .male:
                "Male"
            case .female:
                "Female"
            }
        }
    }
    
    enum InterestedInGender: Int {
        case openToAll = 1
        case men = 2
        case women = 3
        
        var title: String {
            switch self {
            case .men:
                "Men"
            case .women:
                "Women"
            case .openToAll:
                "Open to all"
            }
        }
        
    }
    
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
