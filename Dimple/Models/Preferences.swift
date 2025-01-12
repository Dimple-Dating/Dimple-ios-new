//
//  Preferences.swift
//  Dimple
//
//  Created by Adrian Topka on 09/01/2025.
//

import SwiftUI
import Foundation


// the order matters
enum Preference: CaseIterable {
    case religion
    case ethnicity
    case lookingFor
    case children
    case pets
    case drinking
    case smoking
    case industry
    case diet
    case activities
    case politics
    case bodyType
}

enum LookingForPreference: String, TitleConvertible {
    case openToAll = "1"
    case relationship = "2"
    case somethingCasual = "3"
    case marriage = "4"
    case dontKnowYet = "5"
    
    var title: String {
        switch self {
        case .openToAll:
            return "Open to all"
        case .relationship:
            return "Relationship"
        case .somethingCasual:
            return "Something casual"
        case .marriage:
            return "Marriage"
        case .dontKnowYet:
            return "Don't know yet"
        }
    }
}

enum ReligionPreference: String, TitleConvertible {
    case openToAll = "1"
    case buddhist = "2"
    case catholic = "3"
    case christian = "11"
    case hindu = "4"
    case jewish = "5"
    case muslim = "6"
    case spiritual = "7"
    case agnostic = "8"
    case atheist = "9"
    case other = "10"
    
    var title: String {
        switch self {
        case .openToAll:
            return "Open to all"
        case .buddhist:
            return "Buddhist"
        case .catholic:
            return "Catholic"
        case .christian:
            return "Christian"
        case .hindu:
            return "Hindu"
        case .jewish:
            return "Jewish"
        case .muslim:
            return "Muslim"
        case .spiritual:
            return "Spiritual"
        case .agnostic:
            return "Agnostic"
        case .atheist:
            return "Atheist"
        case .other:
            return "Other"
        }
    }
}

enum EthnicityPreference: String, TitleConvertible {
    case openToAll = "1"
    case whiteCaucasian = "2"
    case blackAfricanDescent = "3"
    case eastAsian = "4"
    case hispanicLatino = "5"
    case middleEastern = "6"
    case pacificIslander = "7"
    case americanIndian = "8"
    case southAsian = "9"
    case other = "10"
    
    var title: String {
        switch self {
        case .openToAll:
            return "Open to all"
        case .whiteCaucasian:
            return "White / Caucasian"
        case .blackAfricanDescent:
            return "Black / African Descent"
        case .eastAsian:
            return "East Asian"
        case .hispanicLatino:
            return "Hispanic / Latino"
        case .middleEastern:
            return "Middle Eastern"
        case .pacificIslander:
            return "Pacific Islander"
        case .americanIndian:
            return "American Indian"
        case .southAsian:
            return "South Asian"
        case .other:
            return "Other"
        }
    }
}

enum ChildrenPreference: String, TitleConvertible {
    case openToAll = "1"
    case wantSomeday = "2"
    case dontWant = "3"
    case haveAndWantMore = "4"
    case haveAndDontWantMore = "5"
    
    var title: String {
        switch self {
        case .openToAll:
            return "Open to all"
        case .wantSomeday:
            return "Want Someday"
        case .dontWant:
            return "Don't want"
        case .haveAndWantMore:
            return "Have & Want More"
        case .haveAndDontWantMore:
            return "Have & Don't Want More"
        }
    }
}

enum PetsPreference: String, TitleConvertible {
    case openToAll = "1"
    case dogs = "2"
    case cats = "3"
    case none = "4"
    
    var title: String {
        switch self {
        case .openToAll:
            return "Open to all"
        case .dogs:
            return "Dogs"
        case .cats:
            return "Cats"
        case .none:
            return "None"
        }
    }
}

enum PoliticsPreference: String, TitleConvertible {
    case openToAll = "1"
    case apolitical = "2"
    case liberal = "3"
    case conservative = "4"
    case moderate = "5"
    case other = "6"
    
    var title: String {
        switch self {
        case .openToAll:
            return "Open to all"
        case .apolitical:
            return "Apolitical"
        case .liberal:
            return "Liberal"
        case .conservative:
            return "Conservative"
        case .moderate:
            return "Moderate"
        case .other:
            return "Other"
        }
    }
}

enum DrinkingPreference: String, TitleConvertible {
    case openToAll = "1"
    case yes = "2"
    case socially = "3"
    case no = "4"
    
    var title: String {
        switch self {
        case .openToAll:
            return "Open to all"
        case .yes:
            return "Yes"
        case .socially:
            return "Socially"
        case .no:
            return "No"
        }
    }
}

enum SmokingPreference: String, TitleConvertible {
    case openToAll = "1"
    case yes = "2"
    case socially = "3"
    case no = "4"
    
    var title: String {
        switch self {
        case .openToAll:
            return "Open to all"
        case .yes:
            return "Yes"
        case .socially:
            return "Socially"
        case .no:
            return "No"
        }
    }
}

enum DietPreference: String, TitleConvertible {
    case openToAll = "1"
    case keto = "2"
    case paleo = "3"
    case vegan = "4"
    case vegetarian = "5"
    case mediterranean = "6"
    case raw = "7"
    case lowCarb = "8"
    case noSugar = "9"
    case glutenFree = "10"
    
    var title: String {
        switch self {
        case .openToAll:
            return "Open to all"
        case .keto:
            return "Keto"
        case .paleo:
            return "Paleo"
        case .vegan:
            return "Vegan"
        case .vegetarian:
            return "Vegetarian"
        case .mediterranean:
            return "Mediterranean"
        case .raw:
            return "Raw"
        case .lowCarb:
            return "Low Carb"
        case .noSugar:
            return "No Sugar"
        case .glutenFree:
            return "Gluten Free"
        }
    }
}

enum IndustryPreference: String, TitleConvertible {
    case openToAll = "1"
    case tech = "2"
    case architect = "3"
    case entrepreneurship = "4"
    case arts = "5"
    case banking = "6"
    case media = "7"
    case fashion = "8"
    case sales = "9"
    case fitness = "10"
    case marketingPR = "11"
    case realEstate = "12"
    case law = "13"
    case healthCare = "14"
    case coaching = "16"
    case socialMediaInfluencer = "17"
    case teaching = "18"
    case ventureCapitalist = "19"
    case privateEquity = "20"
    case dayTrader = "21"
    case investor = "22"
    case finance = "23"
    case analyst = "24"
    case accounting = "25"
    case brandInfluencer = "26"
    case realEstateBroker = "27"
    case realEstateSalesperson = "28"
    case realEstateDeveloper = "29"
    case mortgageBanking = "31"
    case mortgageLending = "32"
    case designer = "33"
    case interiorDesigner = "34"
    case productDevelopment = "35"
    case businessDevelopment = "36"
    case meditationInstructor = "37"
    case wellnessCoach = "38"
    case psychologist = "39"
    case socialWorker = "40"
    case mentalHealthCounselor = "41"
    case photographer = "42"
    
    var title: String {
        switch self {
        case .openToAll: return "Open to all"
        case .tech: return "Tech"
        case .architect: return "Architect"
        case .entrepreneurship: return "Entrepreneurship"
        case .arts: return "Arts"
        case .banking: return "Banking"
        case .media: return "Media"
        case .fashion: return "Fashion"
        case .sales: return "Sales"
        case .fitness: return "Fitness"
        case .marketingPR: return "Marketing & PR"
        case .realEstate: return "Real Estate"
        case .law: return "Law"
        case .healthCare: return "Health Care"
        case .coaching: return "Coaching"
        case .socialMediaInfluencer: return "Social Media Influencer"
        case .teaching: return "Teaching"
        case .ventureCapitalist: return "Venture Capitalist"
        case .privateEquity: return "Private Equity"
        case .dayTrader: return "Day Trader"
        case .investor: return "Investor"
        case .finance: return "Finance"
        case .analyst: return "Analyst"
        case .accounting: return "Accounting"
        case .brandInfluencer: return "Brand Influencer"
        case .realEstateBroker: return "Real Estate Broker"
        case .realEstateSalesperson: return "Real Estate Salesperson"
        case .realEstateDeveloper: return "Real Estate Developer"
        case .mortgageBanking: return "Mortgage Banking"
        case .mortgageLending: return "Mortgage Lending"
        case .designer: return "Designer"
        case .interiorDesigner: return "Interior Designer"
        case .productDevelopment: return "Product Development"
        case .businessDevelopment: return "Business Development"
        case .meditationInstructor: return "Meditation Instructor"
        case .wellnessCoach: return "Wellness Coach"
        case .psychologist: return "Psychologist"
        case .socialWorker: return "Social Worker"
        case .mentalHealthCounselor: return "Mental Health Counselor"
        case .photographer: return "Photographer"
        }
    }
}

enum BodyTypePreference: String, TitleConvertible {
    case openToAll = "1"
    case slender = "2"
    case athletic = "3"
    case average = "4"
    case aFewExtraPounds = "5"
    case full = "6"
    
    var title: String {
        switch self {
        case .openToAll:
            return "Open to all"
        case .slender:
            return "Slender"
        case .athletic:
            return "Athletic"
        case .average:
            return "Average"
        case .aFewExtraPounds:
            return "A Few Extra Pounds"
        case .full:
            return "Full"
        }
    }
}

enum ActivitiesPreference: String, TitleConvertible {
    case openToAll = "1"
    case workoutAndSports = "2"
    case travelling = "3"
    case nightsOut = "4"
    case liveMusic = "5"
    case gaming = "6"
    case faithStudies = "7"
    case artsAndCulture = "8"
    case volunteering = "9"
    case mediation = "10"
    case yoga = "11"
    case pilates = "12"
    case spotify = "13"
    case concerts = "14"
    case singing = "15"
    case playingMusicalInstruments = "16"
    case netflix = "17"
    case realityTV = "18"
    case movies = "19"
    case youtube = "20"
    case instagram = "21"
    case tiktok = "22"
    case podcasts = "23"
    case houseParties = "24"
    case poolParties = "25"
    case clubs = "26"
    case bars = "27"
    case rooftops = "28"
    case hiking = "29"
    case swimming = "30"
    case surfing = "31"
    case theBeach = "32"
    case nbaGames = "33"
    case nflGames = "34"
    case mlbGames = "35"
    case nhlGames = "36"
    case eSports = "37"
    case boxing = "38"
    case soulCycle = "39"
    case barrysBootcamp = "40"
    case crossFit = "41"
    case personalTraining = "42"
    case painting = "43"
    case museums = "44"
    case beerGardens = "45"
    case beerPong = "46"
    case groupSports = "47"
    case running = "48"
    case meetupGroups = "49"
    case sportsGambling = "50"
    case poker = "51"
    case casinoGambling = "52"
    case cooking = "53"
    case golf = "54"
    case karaoke = "55"
    case reading = "56"
    case roadTrips = "57"
    case skiing = "58"
    case snowboarding = "59"
    case tennis = "60"
    case walking = "61"
    case wineries = "62"
    
    var title: String {
        switch self {
        case .openToAll: return "Open to all"
        case .workoutAndSports: return "Workout & Sports"
        case .travelling: return "Travelling"
        case .nightsOut: return "Nights Out"
        case .liveMusic: return "Live Music"
        case .gaming: return "Gaming"
        case .faithStudies: return "Faith Studies"
        case .artsAndCulture: return "Arts & Culture"
        case .volunteering: return "Volunteering"
        case .mediation: return "Mediation"
        case .yoga: return "Yoga"
        case .pilates: return "Pilates"
        case .spotify: return "Spotify"
        case .concerts: return "Concerts"
        case .singing: return "Singing"
        case .playingMusicalInstruments: return "Playing Musical Instruments"
        case .netflix: return "Netflix"
        case .realityTV: return "Reality TV"
        case .movies: return "Movies"
        case .youtube: return "YouTube"
        case .instagram: return "Instagram"
        case .tiktok: return "TikTok"
        case .podcasts: return "Podcasts"
        case .houseParties: return "House Parties"
        case .poolParties: return "Pool Parties"
        case .clubs: return "Clubs"
        case .bars: return "Bars"
        case .rooftops: return "Rooftops"
        case .hiking: return "Hiking"
        case .swimming: return "Swimming"
        case .surfing: return "Surfing"
        case .theBeach: return "The Beach"
        case .nbaGames: return "NBA Games"
        case .nflGames: return "NFL Games"
        case .mlbGames: return "MLB Games"
        case .nhlGames: return "NHL GAMES"
        case .eSports: return "E-Sports"
        case .boxing: return "Boxing"
        case .soulCycle: return "Soul Cycle"
        case .barrysBootcamp: return "Barry's Bootcamp"
        case .crossFit: return "Cross Fit"
        case .personalTraining: return "Personal Training"
        case .painting: return "Painting"
        case .museums: return "Museums"
        case .beerGardens: return "Beer Gardens"
        case .beerPong: return "Beer Pong"
        case .groupSports: return "Group Sports"
        case .running: return "Running"
        case .meetupGroups: return "Meetup Groups"
        case .sportsGambling: return "Sports Gambling"
        case .poker: return "Poker"
        case .casinoGambling: return "Casino Gambling"
        case .cooking: return "Cooking"
        case .golf: return "Golf"
        case .karaoke: return "Karaoke"
        case .reading: return "Reading"
        case .roadTrips: return "Road Trips"
        case .skiing: return "Skiing"
        case .snowboarding: return "Snowboarding"
        case .tennis: return "Tennis"
        case .walking: return "Walking"
        case .wineries: return "Wineries"
        }
    }
}

protocol TitleConvertible {
    var title: String { get }
    static func getTitles(from values: [String]) -> String
}

// Add default implementation for getTitles
extension TitleConvertible where Self: RawRepresentable, Self.RawValue == String {
    static func getTitles(from values: [String]) -> String {
        return values
            .compactMap { Self(rawValue: $0)?.title }
            .joined(separator: ", ")
    }
}
