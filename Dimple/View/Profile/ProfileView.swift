//
//  ProfileView.swift
//  Dimple
//
//  Created by Adrian Topka on 15/11/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var navigationPath = [String]()
    @State private var showCommentsView: Bool = false
    
    
    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    
                    profileDetailsHeader
                    
                    detailsSection
                        .padding()
                    
                    profileImage
                        .padding(.bottom)
                    
                    profileImage
                    
                }
            }
            .navigationDestination(for: String.self) { selection in
                
            }
        }
        .fullScreenCover(isPresented: $showCommentsView, content: {
            ProfileCommentsView()
                .presentationBackground(.clear)
                .ignoresSafeArea()
        })
        
    }
    
    @ViewBuilder
    var profileDetailsHeader: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                Spacer()
                
                Image(.rotate)
                
                Image(.more)
            }
            .padding(.trailing)
            .padding(.bottom)
            
            
            HStack {
                
                Image(.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .shadow(radius: 6)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    
                    Text("124")
                        .bold()
                    
                    Text("Likes")
                        .font(.system(size: 15))
                    
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    
                    Text("67")
                        .bold()
                    
                    Text("Comments")
                        .font(.system(size: 15))
                    
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    
                    Text("39")
                        .bold()
                    
                    Text("Matches")
                        .font(.system(size: 15))
                    
                }
                
            }
            .padding(.horizontal)
            
            Text("Elena")
                .font(.system(size: 21))
                .fontWeight(.medium)
                .padding(.leading)
                .padding(.vertical, 4)
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore elit, sed do eiusmod tempor incididunt ut labore")
                .font(.system(size: 15))
                .padding(.horizontal)
                .padding(.bottom)
            
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
                        .frame(width: 20)
                        .padding(.trailing, 4)
                    
                    Text("19")
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Image(.gift)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .padding(.trailing, 4)
                    
                    Text("19")
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Image(.gift)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .padding(.trailing, 4)
                    
                    Text("19")
                    
                    Divider()
                        .padding(.horizontal)
                    
                    Image(.gift)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .padding(.trailing, 4)
                    
                    Text("19")
                    
                    Divider()
                        .padding(.horizontal)
                    
                }
                .padding()
//                .font(.avenir(style: .regular, size: 14))
                
            }
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(spacing: 12) {
                    
                    Image(.pin)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text("Mapleton, UT\n5 miles away")
                    
                }
                
                HStack(spacing: 12) {
                    
                    Image(.school)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    
                    Text("Brooklyn Collaborative Studies")
                    
                }
                
                HStack(spacing: 12) {
                    
                    Image(.briefcase)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    
                    Text("Art painting at Home")
                    
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
    var profileImage: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            Image(.img1)
                .resizable()
                .scaledToFill()
//                .frame(width: .infinity)
            
            VStack(spacing: 12) {
                
                Button {
                    //
                } label: {
                    
                    VStack(spacing: 3) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 24))
                        
                        Text("321")
                            .font(.avenir(style: .demiBold, size: 13))
                    }
                }
                .padding(.bottom, 12)

                Button {
                    UIView.setAnimationsEnabled(false)
                    self.showCommentsView = true
                } label: {
                    
                    VStack(spacing: 3) {
                        Image(systemName: "ellipsis.bubble.fill")
                            .font(.system(size: 24))
                        
                        Text("321")
                            .font(.avenir(style: .demiBold, size: 13))
                    }
                }

            }
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.5), radius: 3)
            .padding(.trailing, 12)
            .padding(.bottom, 42)
            
        }
        .padding(.top)
        
        
    }
    
}

#Preview {
    ProfileView()
}


//struct ProfileView: View {
//    
//    var body: some View {
//        
//        NavigationStack {
//            
//            ScrollView(showsIndicators: false) {
//                
//                VStack(alignment: .leading) {
//                    
//                    profileDetailsHeader
//                    
//                    detailsSection
//                    
//                    profileImage
//                        .padding(.bottom)
//                    
//                    profileImage
//                    
//                }
//            }
//        }
//        
//    }
//    
//    @ViewBuilder
//    var profileDetailsHeader: some View {
//        
//        VStack(alignment: .leading) {
//            
//            HStack {
//                
//                Spacer()
//                
//                Image(.rotate)
//                
//                Image(.more)
//            }
//            .padding(.trailing)
//            .padding(.bottom)
//            
//            
//            HStack {
//                
//                Image(.avatar)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 80, height: 80)
//                    .clipShape(Circle())
//                    .shadow(radius: 6)
//                
//                Spacer()
//                
//                VStack(alignment: .leading) {
//                    
//                    Text("124")
//                        .bold()
//                    
//                    Text("Likes")
//                        .font(.system(size: 15))
//                    
//                }
//                
//                Spacer()
//                
//                VStack(alignment: .leading) {
//                    
//                    Text("67")
//                        .bold()
//                    
//                    Text("Comments")
//                        .font(.system(size: 15))
//                    
//                }
//                
//                Spacer()
//                
//                VStack(alignment: .leading) {
//                    
//                    Text("39")
//                        .bold()
//                    
//                    Text("Matches")
//                        .font(.system(size: 15))
//                    
//                }
//                
//            }
//            .padding(.horizontal)
//            
//            Text("Elena")
//                .font(.system(size: 21))
//                .fontWeight(.medium)
//                .padding(.leading)
//                .padding(.vertical, 4)
//            
//            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore elit, sed do eiusmod tempor incididunt ut labore")
//                .font(.system(size: 15))
//                .padding(.horizontal)
//                .padding(.bottom)
//            
//        }
//        
//    }
//    
//    @ViewBuilder
//    var detailsSection: some View {
//        
//        VStack {
//            
//            ScrollView(.horizontal) {
//                
//                HStack {
//                    
//                    // user deatails
//                    
//                }
//                
//            }
//            
//            // jakis for na wiecej deatails
//            
//        }
//        
//    }
//    
//    @ViewBuilder
//    var profileImage: some View {
//        
//        VStack {
//            
//            Image(.img1)
//                .resizable()
//                .scaledToFill()
//                .frame(width: .infinity)
//            
//            HStack(spacing: 12) {
//                
//                Spacer()
//                
//                Button(action: {
//                    
//                }, label: {
//                    Image(.chat)
//                })
//                
//                Button(action: {
//                    
//                }, label: {
//                    Image(.heart)
//                })
//                
//                
//                
//            }
//            .padding(.trailing)
//            .padding(.top, 4)
//            
//        }
//        
//    }
//    
//}
