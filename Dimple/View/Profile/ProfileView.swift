//
//  ProfileView.swift
//  Dimple
//
//  Created by Adrian Topka on 15/11/2024.
//

import SwiftUI
import SDWebImageSwiftUI


struct ProfileView: View {
    
    var profileViewModel: ProfileViewModel
    
    var likeTapHandler: (_ profile: Profile, _ photoId: Int?, _ flavorId: Int?) -> ()
    
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    
    @State var endSwipe: Bool = false
    
//    @State private var selectedSectionIndex: Int = 0
//    @State private var isHeartTap: Bool = false
    
    @State private var likedPhotoId: Int = 0
    @State private var likedFlavorId: Int = 0
    
    var numberOfSections: Int {
        if (profileViewModel.profile.flavors?.count ?? 0) > profileViewModel.profile.images.count {
            return profileViewModel.profile.flavors?.count ?? 0
        }
        return profileViewModel.profile.images.count
    }
    
    var body: some View {

        GeometryReader { proxy in
//                let size = proxy.size
        
                
            ZStack {
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading) {
                        
                        profileDetailsHeader
                        
                        detailsSection
                            .padding()
                        
                        ForEach(0..<numberOfSections, id: \.self) { index in
                            
                            if index <= profileViewModel.profile.images.count - 1 {
                                profileImageSection(profileViewModel.profile.images[index])
                                    .padding(.bottom, 12)
                            }
                            
                            if index <= (profileViewModel.profile.flavors?.count ?? 0) - 1 {
                                flavorSection(profileViewModel.profile.flavors![index])
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
            .onAppear {
                UIScrollView.appearance().bounces = false
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
                                swipeToYes()
                            }
                            else{
                                swipeToNo()
                            }
                        }
                        else {
                            offset = .zero
                        }
                    }
                    
                })
        )
        
    }
    
    @ViewBuilder
    var profileDetailsHeader: some View {
        
        VStack {
            ZStack(alignment: .topLeading) {
                
                WebImage(url: URL(string: profileViewModel.profile.avatar?.path ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                
                HStack {
                    
                    WebImage(url: URL(string: profileViewModel.profile.avatar?.path ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40)
                        .clipShape(Circle())
                        .padding(.trailing)
                    
                    Text(profileViewModel.profile.firstname)
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
                didLikeTap(photoId: profileViewModel.profile.avatar?.id)
            } label: {
                
                Image(self.likedPhotoId == profileViewModel.profile.avatar?.id ? .heartFill : .heartActive)
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
                    
                    Text("\(profileViewModel.profile.age)")
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Image(.ruler)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 4)
                    
                    Text(profileViewModel.profile.tall.centimetersTofeetAndInch)
                    
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
                
                if let schools = profileViewModel.profile.schools, !schools.trimmingCharacters(in: .whitespaces).isEmpty {
                    
                    HStack(spacing: 12) {
                        
                        Image(.school)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text(schools)
                        
                    }
                    
                }
                
                if let work = profileViewModel.profile.displayWork() {
                    
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
    func preferencesSection(preference: Preference) -> some View {
        
        if let (icon, title) = profileViewModel.profile.displayPreference(preference) {
            
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
    func profileImageSection(_ photo: UserImage) -> some View {
        
        VStack(alignment: .trailing) {
            
            WebImage(url: URL(string: photo.fullImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 500)
                .clipShape(Rectangle())
                .contentShape(Rectangle())
                
            Button {
                didLikeTap(photoId: photo.id)
            } label: {
                
                Image(self.likedPhotoId == photo.id ? .heartFill : .heartActive)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                   
            }
            .padding(.trailing)
            .padding(.top, 8)

        }
        .padding(.bottom, 36)
        .padding(.top)
        
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
                self.didLikeTap(flavorId: flavor.id)
            } label: {
                
                Image(self.likedFlavorId == flavor.id ? .heartFill : .heartActive)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                   
            }
            .hSpacing(.trailing)
           // .padding(.trailing)
            .padding(.top, 8)
            
        }
        
    }
    
    func swipeToNo() {
        Task {
            await profileViewModel.doNotLikeProfile()
        }
    }
    
    func swipeToYes() {
        Task {
            await profileViewModel.likeProfile()
        }
    }
    
    func didLikeTap(photoId: Int? = nil, flavorId: Int? = nil) {
        
        withAnimation {
            
            if let photoId {
                self.likedPhotoId = photoId
            } else if let flavorId {
                self.likedFlavorId = flavorId
            }
            
        } completion: {
            self.likeTapHandler(profileViewModel.profile, photoId, flavorId)
            self.offset = UIScreen.main.bounds.width
        }

    }
    
}

//#Preview {
//    ProfileView(profileViewModel: .constant(.init(profile: .init(id: "", firstname: "", lastname: nil, email: nil, age: 18, gender: .female, tall: 1222, lat: 122, lng: 122, avatar: nil, images: [], children: "", pets: <#T##String#>, diet: <#T##String#>, drinking: <#T##String#>, smoking: <#T##String#>, ethncity: <#T##String#>, politics: <#T##String#>, religion: <#T##String#>, industry: <#T##String#>, lookingFor: <#T##String#>, activite: <#T##String#>, schools: <#T##String?#>, workPlace: <#T##String?#>, workTitle: <#T##String?#>, isVideoChat: <#T##Bool#>, isActiveInstagram: <#T##Bool#>, isHaveStories: <#T##Bool#>, isInstagramConnected: <#T##Bool#>, isPhotosInstagram: <#T##Bool#>, isSendReadReceipts: <#T##Bool#>, isShowActivityStatus: <#T##Bool#>, isSnoozeMode: <#T##Bool#>, twilioStatus: <#T##Int#>, hiddenOptionActivites: <#T##Bool#>, hiddenOptionChildren: <#T##Bool#>, hiddenOptionDiet: <#T##Bool#>, hiddenOptionDrinking: <#T##Bool#>, hiddenOptionEthnicity: <#T##Bool#>, hiddenOptionIndustry: <#T##Bool#>, hiddenOptionLookingFor: <#T##Bool#>, hiddenOptionPets: <#T##Bool#>, hiddenOptionPolitics: <#T##Bool#>, hiddenOptionReligion: <#T##Bool#>, hiddenOptionSmoking: <#T##Bool#>, createdAt: <#T##String#>, lastActive: <#T##String#>, flavors: <#T##[Flavor]?#>))))
//}

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
