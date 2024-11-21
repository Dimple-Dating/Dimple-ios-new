//
//  ProfileCommentsView.swift
//  Dimple
//
//  Created by Adrian Topka on 21/11/2024.
//

import SwiftUI

struct Comment: Identifiable {
    let id = UUID()
    let avatar: String
    let username: String
    let time: String
    let text: String
    let likes: Int
}

struct ProfileCommentsView: View {
    
    @State private var opacity: Double = 0.0
    @State private var commentsOffset: Double = 600
    
    @State private var comments = [
        Comment(avatar: "person.circle", username: "jazmine.vallexo", time: "9 t", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit 🥺❤️", likes: 415),
        Comment(avatar: "person.circle.fill", username: "cheryltaka", time: "10 t", text: "Duis aute irure dolor in reprehe ❤️", likes: 10),
        Comment(avatar: "person.crop.circle", username: "ol.lai", time: "4 t", text: "Excepteur sint occaecat cupidatat 😅🥰", likes: 1),
        Comment(avatar: "person.2.circle", username: "itz_waxid_r", time: "6 t", text: "non proident, sunt in culpa qui officia deserunt mollit anim id est laborum😭", likes: 2)
    ]
    
    @State private var newComment = ""
    private let reactions = ["❤️", "🙌", "🔥", "👏", "😢", "😍", "😮", "😂"]

    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Color.black
                .opacity(opacity)
                .animation(.easeInOut(duration: 0.2), value: opacity)
            
            VStack {
                
                Spacer()
                
                Capsule()
                    .frame(width: 40, height: 5)
                    .foregroundStyle(.gray)
                
                // Header
                Text("Comments")
                    .font(.headline)
                    .padding(.vertical, 4)
                
                Divider()
                
                // Comments List
                List(comments) { comment in
                    
                    HStack(alignment: .top) {
                        // Avatar
                        Image(systemName: comment.avatar)
                            .resizable()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                        
                        // Comment Content
                        VStack(alignment: .leading, spacing: 4) {
                            
                            HStack {
                                Text(comment.username)
                                    .font(.avenir(style: .demiBold, size: 14))
                                
                                Text(comment.time)
                                    .font(.avenir(style: .regular, size: 12))
                                    .foregroundColor(.gray)
                            }
                            
                            Text(comment.text)
                                .font(.avenir(style: .regular, size: 14))
                           
                        }
                        
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
                .frame(height: 400)
                
                
                Divider()
                
                // Reactions and Comment Input
                VStack {
                    // Reactions
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(reactions, id: \.self) { reaction in
                                Text(reaction)
                                    .font(.title)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 8)
                    
                    // Input Field
                    HStack {
                        TextField("Add comment...", text: $newComment)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            // Action to send comment
                            if !newComment.isEmpty {
                                comments.append(Comment(avatar: "person.circle", username: "You", time: "Now", text: newComment, likes: 0))
                                newComment = ""
                            }
                        }) {
                            Image(systemName: "paperplane")
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
                .padding(.vertical, 8)
            }
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .foregroundStyle(.white)
            )
            .offset(y: commentsOffset)
            .frame(height: 490)
            .padding(.bottom, 62)
            .animation(.linear(duration: 0.2), value: commentsOffset)
            
        }
        .onAppear {
            UIView.setAnimationsEnabled(true)
            self.opacity = 0.6
            self.commentsOffset = 0
        }
        
    }
}

#Preview {
    ProfileCommentsView()
}
