//
//  MatchingView.swift
//  Dimple
//
//  Created by Adrian Topka on 15/11/2024.
//

import SwiftUI
import Observation

// /users/list

@Observable
class HomeViewModel {
    
    var users: [User] = []
    
    init(){
        users = [.init(name: "dsa"), .init(name: "aa"), .init(name: "ccc"), .init(name: "dsdsaa"), .init(name: "ds12a")]
    }
    
}


struct MatchingView: View {
    
    var viewModel: HomeViewModel = .init()
    
    var body: some View {
        
        ZStack(alignment: .center) {
                
            ForEach(viewModel.users) { color in
                ProfileView()
            }
                
        }
    
    }
    
}

#Preview {
    MatchingView()
}



@Observable
final class MatchingViewModel {
    
}
