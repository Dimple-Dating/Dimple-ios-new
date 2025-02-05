//
//  DimpleApp.swift
//  Dimple
//
//  Created by Adrian on 20/08/2024.
//

import SwiftUI
import SwiftData

@main
struct DimpleApp: App {
    
    @AppStorage("token") var token: String = ""
    @AppStorage("onboardingFinished") var onboardingFinished: Bool = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        
        WindowGroup {
            
            if onboardingFinished {
                MainTabbarView()
            } else {
                LoginView()
            }
            
        }
        .modelContainer(sharedModelContainer)
    }
}
