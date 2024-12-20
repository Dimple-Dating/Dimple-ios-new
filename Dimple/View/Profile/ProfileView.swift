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
    
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    
    @State var endSwipe: Bool = false
    
    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            
            GeometryReader{proxy in
//                let size = proxy.size
            
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading) {
                        
                        profileDetailsHeader
                        
                        detailsSection
                            .padding()
                        //
                        profileImage
                            .padding(.bottom)
                        
                        profileImage
                        
                    }
                    //            }
                    //            .navigationDestination(for: String.self) { selection in
                    //
                }
                .ignoresSafeArea()
            
            }
            .offset(x: offset)
        }
        .fullScreenCover(isPresented: $showCommentsView, content: {
            ProfileCommentsView()
                .presentationBackground(.clear)
                .ignoresSafeArea()
        })
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
                    
                    let width = getRect().width - 50
                    let translation = value.translation.width
                    
                    let checkingStatus = (translation > 0 ? translation : -translation)
                    
                    
                    withAnimation{
                        if checkingStatus > (width / 2){
                            // remove Card...
                            offset = (translation > 0 ? width : -width) * 2
//                            endSwipeActions()
                            
                            if translation > 0{
//                                rightSwipe()
                            }
                            else{
//                                leftSwipe()
                            }
                        }
                        else{
                            // reset..
                            offset = .zero
                        }
                    }
                })
        )
        
    }
    
    @ViewBuilder
    var profileDetailsHeader: some View {
        
        ZStack(alignment: .topLeading) {
            
            Image(.avatar)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
            
            HStack {
                
                Image(.avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40)
                    .clipShape(Circle())
                    .padding(.trailing)
                
                Text("Martyna")
                    .font(.avenir(style: .medium, size: 20))
                    .textCase(.uppercase)
                    .foregroundStyle(.white)
                    .shadow(radius: 2)
                
                Spacer()
                
                Image(.rotate)
                    .foregroundStyle(.white)
                
                Image(.more)
                    .foregroundStyle(.white)
                
            }
            .frame(height: 150)
            .padding(.horizontal)
            .padding(.bottom)
            
            Spacer()
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
        
        VStack(alignment: .trailing) {
            
            Image(.img1)
                .resizable()
                .scaledToFill()
            
                
            Button {
                //
            } label: {
                
                Image(systemName: "heart")
                    .font(.avenir(style: .regular, size: 24))
                
                    .foregroundColor(.black)
                   
            }
            .padding(.trailing)
            .padding(.top, 8)

            
        }
        .padding(.bottom, 36)
        .padding(.top)
        
        
    }
    
}

#Preview {
    ProfileView()
}


struct ProfileView: View {
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading) {
                    
                    profileDetailsHeader
                    
                    detailsSection
                    
                    profileImage
                        .padding(.bottom)
                    
                    profileImage
                    
                }
            }
        }
        
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
        
        VStack {
            
            ScrollView(.horizontal) {
                
                HStack {
                    
                    // user deatails
                    
                }
                
            }
            
            // jakis for na wiecej deatails
            
        }
        
    }
    
    @ViewBuilder
    var profileImage: some View {
        
        VStack {
            
            Image(.img1)
                .resizable()
                .scaledToFill()
                .frame(width: .infinity)
            
            HStack(spacing: 12) {
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image(.chat)
                })
                
                Button(action: {
                    
                }, label: {
                    Image(.heart)
                })
                
                
                
            }
            .padding(.trailing)
            .padding(.top, 4)
            
        }
        
    }
    
}
 Extending View to get Bounds....
extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
