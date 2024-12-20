//
//  MatchingView.swift
//  Dimple
//
//  Created by Adrian Topka on 15/11/2024.
//

import SwiftUI
import Observation

// /users/list




struct MatchingView: View {
    
    @State private var testUsers: [User] = [.init(name: "dsa"), .init(name: "aa"), .init(name: "ccc"), .init(name: "dsdsaa"), .init(name: "ds12a"),]
    
    var body: some View {
        
//        VStack {
            
            ZStack {
                
                ForEach(testUsers, id: \.name) { test in
                    ProfileView()
                        .padding()
                }
                
            }
            
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
}

#Preview {
    MatchingView()
}



@Observable
final class MatchingViewModel {
    
}
