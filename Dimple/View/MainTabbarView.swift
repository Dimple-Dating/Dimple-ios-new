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

private struct MainTabContentView: View {
    
    @Binding var selectedTab: Tab
    
    var viewModel: MatchingViewModel

    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            MatchingView(viewModel: self.viewModel)
                .tabItem {
                    Image(selectedTab == .profiles ? .dimpleActive : .dimple)
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

            AdmirersView()
                .tabItem {
                    Image(selectedTab == .admirers ? .heartActive : .heart)
                }
                .tag(Tab.admirers)

            Text("Menu View")
                .tabItem {
                    Image(.menu)
                }
                .tag(Tab.menu)
        }
        
    }
    
}

struct MainTabbarView: View {
    
    @State private var livematchIsOn: Bool = true
    
    @State private var selectedTab: Tab = .profiles
    
    @State private var tabState: Visibility = .visible
    
    @State private var showMenu: Bool = false
    
    @State private var lastSelectedTab: Tab = .profiles
    
    var viewModel: MatchingViewModel = .init()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .trailing) {
                
                Color.black
                
                MainTabContentView(selectedTab: $selectedTab, viewModel: viewModel)
                    .clipShape(RoundedRectangle(cornerRadius: showMenu ? 20 : 0, style: .continuous))
                    .offset(x: showMenu ? -geometry.size.width * 0.8 : 0)
                    .scaleEffect(showMenu ? 0.88 : 1.0)
                    .compositingGroup()
                    .animation(.easeInOut(duration: 0.3), value: showMenu)
                
                if showMenu {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showMenu = false
                        }
                }
                
                if showMenu {
                    menuView
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.3), value: showMenu)
                }
            }
            .ignoresSafeArea()
            .onChange(of: selectedTab) { _, newValue in
                if newValue == .menu {
                    showMenu = true
                    selectedTab = lastSelectedTab
                } else {
                    lastSelectedTab = newValue
                }
            }
        }
        
    }
    
    var menuView: some View {
        
        VStack(alignment: .leading) {
            
            Image(.logoWhite)
                .resizable()
                .scaledToFit()
                .frame(width: 190)
                .padding(.vertical, 50)
                .padding(.top, 60)
                .padding(.horizontal, 32)
               
            Group {
                
                menuButton(title: "profile") {
                    
                }
                
                menuButton(title: "preferences") {
                    
                }
                
                menuButton(title: "settings") {
                    
                }
                
                Toggle(isOn: $livematchIsOn) {
                    menuButton(title: "livematch") {
                        
                    }
                }
                .padding(.trailing, 24)
                
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 32)
            
            Capsule()
                .fill(.white)
                .frame(height: 3)
                .padding(.horizontal, 32)
                .padding(.trailing, 24)
                .padding(.top)
                .padding(.bottom, 12)
            
            HStack {
                
                Text("100 mins left")
                    .font(.avenir(style: .regular, size: 14))
                    .foregroundStyle(.white)
                    .kerning(1.4)
                
                Spacer()
                
                Button {
                    // info
                } label: {
                    Image(.info)
                }

                
            }
            .padding(.horizontal, 32)
            .padding(.trailing, 24)
            .padding(.bottom)

            Text("Private LIVEMATCH Event\nSunday and Tuesday\n9PM-10PM")
                .font(.avenir(style: .regular, size: 14))
                .foregroundStyle(.white)
                .kerning(1.4)
                .padding(.horizontal, 32)
                .padding(.trailing, 24)
                .padding(.bottom, 50)
            
            HStack {
                
                socialButton(image: .init(.insta)) {
                    
                }
                
                socialButton(image: .init(.tiktok)) {
                    
                }
                
                socialButton(image: .init(.website)) {
                    
                }
                
                socialButton(image: .init(.mail)) {
                    
                }
                
            }
            .padding(.leading, 32)
            .padding(.bottom, 32)
            
            Button {
                //terms
            } label: {
                Text("Terms of Service")
                    .font(.avenir(style: .regular, size: 14))
                    .kerning(1.8)
                    .foregroundStyle(.white)
            }
            .padding(.leading, 42)
            .padding(.bottom)

            Button {
                //policy
            } label: {
                Text("Privacy Policy")
                    .font(.avenir(style: .regular, size: 14))
                    .kerning(1.8)
                    .foregroundStyle(.white)
            }
            .padding(.leading, 42)
            
            Spacer()
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.78)
    }
    
    func menuButton(title: String, _ action: @escaping () -> ()) -> some View {
        
        Button {
            action()
        } label: {
            Text(title)
                .font(.avenir(style: .regular, size: 20))
                .textCase(.uppercase)
                .foregroundStyle(.white)
                .kerning(1.8)
            
        }

    }
    
    func socialButton(image: Image, _ action: @escaping () -> ()) -> some View {
        
        Button {
            action()
        } label: {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 52)
        }

        
    }
    
}

#Preview {
    MainTabbarView()
}
