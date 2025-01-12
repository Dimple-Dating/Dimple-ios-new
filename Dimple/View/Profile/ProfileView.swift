//
//  ProfileView.swift
//  Dimple
//
//  Created by Adrian Topka on 15/11/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    var profile: Profile
    
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    
    @State var endSwipe: Bool = false
    
    var numberOfSections: Int {
        if (profile.flavors?.count ?? 0) > profile.images.count {
            return profile.flavors?.count ?? 0
        }
        return profile.images.count
    }
    
    init(profile: Profile) {
        self.profile = profile
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
            
        GeometryReader { proxy in
                let size = proxy.size
        
            ZStack {
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading) {
                        
                        profileDetailsHeader
                        
                        detailsSection
                            .padding()
                        
                        ForEach(0..<numberOfSections, id: \.self) { index in
                            
                            if index <= profile.images.count - 1 {
                                profileImage(profile.images[index].fullImageUrl)
                                    .padding(.bottom, 12)
                            }
                            
                            if index <= (profile.flavors?.count ?? 0) - 1 {
                                flavorSection(profile.flavors![index])
                                    .padding(.horizontal)
                                    .padding(.bottom, 12)
                            }
                            
                        }
                        
                    }
                    .background(.white)
                    .padding(.bottom, 52)
                    
                }
                .ignoresSafeArea()
                .blur(radius: isDragging ? 4 : 0)
                
                if isDragging {
                    
                    Text(offset > 0 ? "YES" : "NO")
                        .font(.avenir(style: .medium, size: 40))
                        .foregroundStyle(.white)
                        .hSpacing(offset > 0 ? .leading : .trailing)
                        .padding(.horizontal, 32)
                    
                }
                
            }
        
        }
        .offset(x: offset)
        .gesture(
            DragGesture()
                .updating($isDragging, body: { value, out, _ in
                    out = true
                })
                .onChanged({ value in
                    
                    let translation = value.translation.width
                    offset = (isDragging ? translation : .zero)
                })
                .onEnded({ value in
                    
                    let width = getRect().width //- 80
                    let translation = value.translation.width
                    
                    let checkingStatus = (translation > 0 ? translation : -translation)
                    
                    withAnimation {
                        if checkingStatus > (width / 2) {
                            // remove Card...
                            offset = (translation > 0 ? width : -width) * 2
//                            endSwipeActions()
                            
                            if translation > 0 {
                                rightSwipe()
                            }
                            else{
                                leftSwipe()
                            }
                        }
                        else {
                            offset = .zero
                        }
                    }
                    
                })
        )
        
    }
    
    func leftSwipe(){
        print("Left Swiped")
    }
    
    func rightSwipe(){
        print("Right Swiped")
    }
    
    @ViewBuilder
    var profileDetailsHeader: some View {
        
        VStack {
            ZStack(alignment: .topLeading) {
                
                WebImage(url: URL(string: profile.avatar?.path ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                
                HStack {
                    
                    WebImage(url: URL(string: profile.avatar?.path ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40)
                        .clipShape(Circle())
                        .padding(.trailing)
                    
                    Text(profile.firstname)
                        .font(.avenir(style: .medium, size: 20))
                        .textCase(.uppercase)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.5), radius: 3)
                    
                    Spacer()
                    
                    Image(.rotate)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.7), radius: 3)
                    
                    Image(.more)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.7), radius: 3)
                    
                }
                .frame(height: 150)
                .padding(.horizontal)
                .padding(.bottom)
                
                Spacer()
            }
            
            Button {
                //
            } label: {
                
                Image(.heartActive)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                   
            }
            .hSpacing(.trailing)
            .padding(.trailing)
            .padding(.top, 8)
            
        }
            
    }
    
    @ViewBuilder
    var detailsSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack {
                    
                    Image(.gift)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 4)
                    
                    Text("\(profile.age)")
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Image(.ruler)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 4)
                    
                    Text(profile.tall.centimetersTofeetAndInch)
                    
                    ForEach(Preference.allCases, id: \.self) { preference in
                        preferencesSection(preference: preference)
                    }
                    
                }
                .padding()
                
            }
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(spacing: 12) {
                    
                    Image(.pin)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Mapleton, UT\n5 miles away")
                    
                }
                
                if let schools = profile.schools, !schools.trimmingCharacters(in: .whitespaces).isEmpty {
                    
                    HStack(spacing: 12) {
                        
                        Image(.school)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text(schools)
                        
                    }
                    
                }
                
                if let work = profile.displayWork() {
                    
                    HStack(spacing: 12) {
                        
                        Image(.briefcase)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                        
                        Text(work)
                        
                    }
                    
                }
                
            }
            .padding(.horizontal)
            .padding(.bottom)
            
        }
        .font(.avenir(style: .regular, size: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.black.opacity(0.2), lineWidth: 0.6)
        }
        
    }
    
    @ViewBuilder
    func profileImage(_ imageUrl: String) -> some View {
        
        VStack(alignment: .trailing) {
            
            WebImage(url: URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 500)
                .clipShape(Rectangle())
                
            Button {
                //
            } label: {
                
                Image(.heartActive)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                   
            }
            .padding(.trailing)
            .padding(.top, 8)

            
        }
        .padding(.bottom, 36)
        .padding(.top)
        
        
    }
    
    @ViewBuilder
    func preferencesSection(preference: Preference) -> some View {
        
        if let (icon, title) = profile.displayPreference(preference) {
            
            HStack {
                
                
                Divider()
                    .padding(.horizontal)
                
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 4)
                
                Text(title)
                
            }
            
        }
        
    }
    
    @ViewBuilder
    func flavorSection(_ flavor: Flavor) -> some View {
        
        VStack {
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text(flavor.header)
                    .font(.avenir(style: .medium, size: 16))
                    .textCase(.uppercase)
                    .tracking(1.6)
                    .padding(.bottom, 8)
                
                Text(flavor.content)
                    .font(.avenir(style: .regular, size: 16))
                
            }
            .hSpacing(.leading)
            .padding()
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.black.opacity(0.2), lineWidth: 0.6)
            }
            
            Button {
                //
            } label: {
                
                Image(.heartActive)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                   
            }
            .hSpacing(.trailing)
            .padding(.trailing)
            .padding(.top, 8)
            
        }
        
    }
    
}

#Preview {
    ProfileView(profile: Profile.preview)
}

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
