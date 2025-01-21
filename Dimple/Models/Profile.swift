//
//  Profile.swift
//  Dimple
//
//  Created by Adrian Topka on 09/01/2025.
//

import SwiftUI
import Foundation


struct Profile: Identifiable, Decodable {
    
    // MARK: Basic Info
    let id: String
    let firstname: String
    let lastname: String?
    let email: String?
    let age: Int
    let gender: Gender
    let tall: Double
    
    // MARK: Location
    let lat: Double
    let lng: Double
    
    // MARK: Images
    let avatar: UserImage?
    let images: [UserImage]
    
    // MARK: Personal Info
    let children: String
    let pets: String
    let diet: String
    let drinking: String
    let smoking: String
    let ethncity: String
    let politics: String
    let religion: String
    let industry: String
    let lookingFor: String
    let activite: String
    
    // MARK: Education & Work
    let schools: String?
    let workPlace: String?
    let workTitle: String?
    
    // MARK:  Social & App Settings
    let isVideoChat: Bool
    let isActiveInstagram: Bool
    let isHaveStories: Bool
    let isInstagramConnected: Bool
    let isPhotosInstagram: Bool
    let isSendReadReceipts: Bool
    let isShowActivityStatus: Bool
    let isSnoozeMode: Bool
    let twilioStatus: Int
    
    // MARK: Privacy Settings
    let hiddenOptionActivites: Bool
    let hiddenOptionChildren: Bool
    let hiddenOptionDiet: Bool
    let hiddenOptionDrinking: Bool
    let hiddenOptionEthnicity: Bool
    let hiddenOptionIndustry: Bool
    let hiddenOptionLookingFor: Bool
    let hiddenOptionPets: Bool
    let hiddenOptionPolitics: Bool
    let hiddenOptionReligion: Bool
    let hiddenOptionSmoking: Bool
    
    // MARK: Timestamps
    let createdAt: String
    let lastActive: String
    
    // MARK: Optional Fields
    let flavors: [Flavor]?
    
    private enum CodingKeys: String, CodingKey {
        case id, firstname, lastname, email, age, gender, tall
        case lat, lng
        case avatar, images
        case children, pets, diet, drinking, smoking, ethncity, politics, religion, industry
        case lookingFor = "looking_for"
        case activite
        case schools
        case workPlace = "work_place"
        case workTitle = "work_title"
        case isVideoChat = "isVideoChat"
        case isActiveInstagram, isHaveStories, isInstagramConnected, isPhotosInstagram
        case isSendReadReceipts, isShowActivityStatus, isSnoozeMode
        case twilioStatus
        case hiddenOptionActivites, hiddenOptionChildren, hiddenOptionDiet
        case hiddenOptionDrinking, hiddenOptionEthnicity, hiddenOptionIndustry
        case hiddenOptionLookingFor = "hiddenOptionLooking_for"
        case hiddenOptionPets, hiddenOptionPolitics, hiddenOptionReligion
        case hiddenOptionSmoking
        case createdAt = "created_at"
        case lastActive = "last_active"
        case flavors
    }
    
}


// MARK: - UserImage
struct UserImage: Codable {
    let id: Int
    let imageOrder: Int
    let localIdentifier: String
    let path: String

    var thumbnailUrl: String {
        path.replacingOccurrences(
            of: "https://s3.us-east-2.amazonaws.com/dimple.bucket/raw_images/",
            with: "https://d3q6c6krposoe8.cloudfront.net/100x100/"
        )
    }
    
    var fullImageUrl: String {
            path.replacingOccurrences(
                of: "https://s3.us-east-2.amazonaws.com/dimple.bucket/raw_images/",
                with: "https://d3q6c6krposoe8.cloudfront.net/890x890/"
            )
        }
    
}

//MARK: - Flavors
struct Flavor: Codable {
    let id: Int
    let content: String
    let header: String
}

// MARK: - Displays
extension Profile {
    
    func displayWork() -> String? {
        
        var result: String = ""
       
        if let workTitle {
            result = workTitle
            if let workPlace {
                result.append(" at \(workPlace)")
            }
            return result
        } else {
            return nil
        }
            
        
    }
    
    func displayPreference(_ preference: Preference) -> (Image, String)? {
        
        switch preference {
        case .lookingFor:
            if hiddenOptionLookingFor || lookingFor == "1" { return nil }
            return (.init(.search), LookingForPreference.getTitles(from: lookingFor.toArray()))
            
        case .religion:
            if hiddenOptionReligion || religion == "1" { return nil }
            return (.init(.praying), ReligionPreference.getTitles(from: religion.toArray()))
            
        case .ethnicity:
            if hiddenOptionEthnicity || ethncity == "1" { return nil }
            return (.init(.globe), EthnicityPreference.getTitles(from: ethncity.toArray()))
            
        case .children:
            if hiddenOptionChildren || children == "1" { return nil }
            return (.init(.babyCarriage), ChildrenPreference.getTitles(from: children.toArray()))
            
        case .pets:
            if hiddenOptionPets || pets == "1" { return nil }
            return (.init(.paw), PetsPreference.getTitles(from: pets.toArray()))
            
        case .politics:
            if hiddenOptionPolitics || politics == "1" { return nil }
            return (.init(.landmark), PoliticsPreference.getTitles(from: politics.toArray()))
            
        case .drinking:
            if hiddenOptionDrinking || drinking == "1" { return nil }
            return (.init(.wineGlass), DrinkingPreference.getTitles(from: drinking.toArray()))
            
        case .smoking:
            if hiddenOptionSmoking || smoking == "1" { return nil }
            return (.init(.smoking), SmokingPreference.getTitles(from: smoking.toArray()))
            
        case .diet:
            if hiddenOptionDiet || diet == "1" { return nil }
            return (.init(.apple), DietPreference.getTitles(from: diet.toArray()))
            
        case .industry:
            if hiddenOptionIndustry || industry == "1" { return nil }
            return (.init(.settings), IndustryPreference.getTitles(from: industry.toArray()))
            
        case .bodyType:
            return nil
        case .activities:
            if hiddenOptionActivites || activite == "1" { return nil }
            return (.init(.tennisBall), ActivitiesPreference.getTitles(from: activite.toArray()))
        }
    }
    
}

// MARK: - Preview Helper
extension Profile {
    static var preview: Profile {
        Profile(
            id: "1",
            firstname: "John",
            lastname: "Doe",
            email: "john@example.com",
            age: 25,
            gender: .male,
            tall: 180.0,
            lat: 40.7128,
            lng: -74.0060,
            avatar: nil,
            images: [],
            children: "0",
            pets: "1",
            diet: "1",
            drinking: "1",
            smoking: "0",
            ethncity: "1",
            politics: "1",
            religion: "1",
            industry: "1",
            lookingFor: "1",
            activite: "1",
            schools: "University",
            workPlace: "Company",
            workTitle: "Developer",
            isVideoChat: true,
            isActiveInstagram: false,
            isHaveStories: false,
            isInstagramConnected: false,
            isPhotosInstagram: false,
            isSendReadReceipts: true,
            isShowActivityStatus: true,
            isSnoozeMode: false,
            twilioStatus: 1,
            hiddenOptionActivites: false,
            hiddenOptionChildren: false,
            hiddenOptionDiet: false,
            hiddenOptionDrinking: false,
            hiddenOptionEthnicity: false,
            hiddenOptionIndustry: false,
            hiddenOptionLookingFor: false,
            hiddenOptionPets: false,
            hiddenOptionPolitics: false,
            hiddenOptionReligion: false,
            hiddenOptionSmoking: false,
            createdAt: "2024-01-01",
            lastActive: "2024-01-01",
            flavors: nil
        )
    }
}
