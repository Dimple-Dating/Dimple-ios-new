//
//  ProfileView.swift
//  Dimple
//
//  Created by Adrian Topka on 15/11/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @State var offset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    
    @State var endSwipe: Bool = false
    
    init() {
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
                        
                        profileImage
                            .padding(.bottom)
                        
                        profileImage
                        
                    }
                    .background(.white)
                    
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

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
