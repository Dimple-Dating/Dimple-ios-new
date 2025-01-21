//
//  LikeCommentView.swift
//  Dimple
//
//  Created by Adrian Topka on 21/01/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct LikeCommentView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var profile: Profile
    var commentPhotoId: Int?
    var commentFlavorId: Int?
    
    @State private var commentText: String = ""
    
    @State private var titleTextOpacity: Double = 1
    
//    @State private var keyboardHeight: CGFloat = 0
    @State private var isCommentTyping: Bool = false
    @FocusState private var focused: Bool
    
    var body: some View {
        
//        GeometryReader { _ in
            
            ZStack(alignment: .bottom) {
                
                VStack(spacing: 0) {
                    
                    Divider()
                    
                    Text("You sent like!")
                        .font(.avenir(style: .medium, size: 16))
                        .opacity(titleTextOpacity)
                        .padding(.top)
                        .padding(.bottom, 32)
                    
                    if let commentPhotoId {
                        
                        if let photoUrl = profile.images.first(where: {$0.id == commentPhotoId})?.fullImageUrl {
                            
                            WebImage(url: URL(string: photoUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: UIScreen.main.bounds.height * 0.55)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .contentShape(Rectangle())
                                .padding(.bottom)
                                .padding(.horizontal, 24)
                            
                        } else if let photoUrl = profile.avatar?.fullImageUrl {
                            
                            WebImage(url: URL(string: photoUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: UIScreen.main.bounds.height * 0.55)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .contentShape(Rectangle())
                                .padding(.bottom)
                                .padding(.horizontal, 24)
                        }
                        
                    } else if let commentFlavorId, let flavor = profile.flavors?.first(where: {$0.id == commentFlavorId}) {
                        
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
                        .padding(.horizontal, 24)
                        
                    }
                    
                    Spacer()
                    
                }
                
                if isCommentTyping {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                self.isCommentTyping = false
                                self.focused = false
                            }
                        }
                }
                
                HStack {
                    
                    Image(.avatar)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    
                    HStack {
                        
                        TextField("Add a comment...", text: $commentText)
                            .font(.avenir(style: .regular, size: 14))
                            .tint(.black)
                            .focused($focused)
                            .padding(8)
                            .padding(.vertical, 4)
                            .onTapGesture {
                                self.isCommentTyping = true
//                                self.focused = true
                            }
                        
                        Button {
                            // send
                        } label: {
                            Text("Send")
                                .font(.avenir(style: .medium, size: 14))
                                .foregroundStyle(isCommentTyping ? .black : .white)
                        }
                        .padding(.trailing, 8)
                        
                    }
                    .background {
                        Rectangle()
                            .fill(.black.opacity(0.2))
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 8,
                                    bottomLeadingRadius: 0,
                                    bottomTrailingRadius: 8,
                                    topTrailingRadius: 8
                                )
                                .stroke(lineWidth: 0.6)
                            )
                            .background {
                                Rectangle()
                                    .fill(.white)
                                    .clipShape(
                                        .rect(
                                            topLeadingRadius: 8,
                                            bottomLeadingRadius: 0,
                                            bottomTrailingRadius: 8,
                                            topTrailingRadius: 8
                                        )
                                    )
                                
                            }
                        
                    }
                    
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 64)
//                .padding(.bottom, keyboardHeight)
//                .onReceive(Publishers.keyboardHeight) { height in
//                    withAnimation {
//                        isCommentTyping = true
//                        keyboardHeight = height
//                    }
//                }
            }
            
//        }
//        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeInOut) {
                    titleTextOpacity = 0
                }
            }
            
            
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back to swiping")
                    }
                    .font(.avenir(style: .regular, size: 14))
                    .foregroundStyle(.black)
                }
            }
        }
        
    }
    
}

//#Preview {
//    LikeCommentView(profileViewModel: .constant(.init(profile: .)))
//}


import Combine
import UIKit

//extension Publishers {
//    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
//        
//        let willShow = NotificationCenter.default
//            .publisher(for: UIResponder.keyboardWillShowNotification)
//            .compactMap { notification -> CGFloat? in
//                // Wyciągamy finalną klatkę klawiatury
//                guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
//                    return nil
//                }
//                return frame.height
//            }
//        
//        let willHide = NotificationCenter.default
//            .publisher(for: UIResponder.keyboardWillHideNotification)
//            .map { _ -> CGFloat in
//                0
//            }
//        
//        return Merge(willShow, willHide)
//            .eraseToAnyPublisher()
//    }
//}
