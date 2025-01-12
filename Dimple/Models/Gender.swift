//
//  Gender.swift
//  Dimple
//
//  Created by Adrian Topka on 09/01/2025.
//

import Foundation

enum Gender: Int, Codable {
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

enum InterestedInGender: Int, Codable {
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
