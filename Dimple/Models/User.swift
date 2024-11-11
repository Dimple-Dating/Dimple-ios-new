//
//  User.swift
//  Dimple
//
//  Created by Adrian Topka on 11/11/2024.
//

import Foundation

struct User {
    
    var name: String = ""
    var lastName: String = ""
    var email: String = ""
    var userName: String = ""
    var gender: Int? = nil
    var age: String = ""
    var interestedIn: String = ""
    var height: Float = 0
    
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
    
}
