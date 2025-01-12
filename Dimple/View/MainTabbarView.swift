//
//  MainTabbarView.swift
//  Dimple
//
//  Created by Adrian Topka on 08/11/2024.
//

import SwiftUI

enum Tab: String {
    case profiles
    case chat
    case stories
    case admirers
    case menu
}

struct MainTabbarView: View {
    
    @State private var selectedTab: Tab = .profiles
    
    @State private var tabState: Visibility = .visible
    
    var viewModel: MatchingViewModel = .init()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {

            MatchingView(viewModel: self.viewModel)
                .tabItem {
                    Image(selectedTab == .profiles ? .dimpleActive : .dimple)
                        .foregroundStyle(.black)
                }
                .tag(Tab.profiles)
            
            Text("Chat View")
                .tabItem {
                    Image(selectedTab == .chat ? .chatActive : .chat)
                }
                .tag(Tab.chat)
            
            Text("Stories View")
                .tabItem {
                    Image(selectedTab == .stories ? .plusActive : .plus)
                }
                .tag(Tab.stories)
            
            Text("Admirers View")
                .tabItem {
                    Image(selectedTab == .admirers ? .heartActive : .heart)
                }
                .tag(Tab.admirers)
            
            Text("Menu View")
                .tabItem {
                    Image(selectedTab == .menu ? .menuActive : .menu)
                }
                .tag(Tab.menu)
            
        }
        
    }
}

#Preview {
    MainTabbarView()
}
