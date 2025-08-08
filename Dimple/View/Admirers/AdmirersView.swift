//
//  AdmirersView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/08/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct AdmirersView: View {
    
    @State private var viewModel: AdmirersViewModel = .init()
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                ForEach(viewModel.admirers, id: \.id) { admirer in
                    admireRow(admirer)
                }
                
            }
            .padding()
            
        }
        .onAppear {
            Task {
                await viewModel.fetchAdmirers()
            }
        }
    }
    
    func admireRow(_ admirer: Admirer) -> some View {
        
        HStack(alignment: .center, spacing: 12) {
            
            WebImage(url: URL(string: admirer.userAvatarPath ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 42, height: 42)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                (
                    Text(admirer.username ?? "")
                        .fontWeight(.medium) +
                    Text(titleText(for: admirer))
                )
                .font(.avenir(style: .regular, size: 15))
                .multilineTextAlignment(.leading)

                // Subtitle (comment or flavor content)
                if let subtitle = subtitleText(for: admirer), !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }

            Spacer()

            // Flavor view on the right if available
            if let header = admirer.flavorHeader,
               let content = admirer.flavorContent {
                VStack(alignment: .trailing, spacing: 4) {
                    Text(header.uppercased())
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                    Text(content)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Helper Text Logic

    private func titleText(for admirer: Admirer) -> String {
        if admirer.type == "like" && (admirer.subject == "profile" || admirer.subject == "story") {
            return " liked your \(admirer.subject ?? "")"
        }

        if admirer.photoComment != nil,
           admirer.type == "comment",
           (admirer.subject == "photo" || admirer.subject == "story") {
            return " liked and commented your \(admirer.subject ?? ""):"
        }

        if admirer.type == "like", admirer.subject == "photo" {
            return " liked your photo"
        }

        if admirer.type == "comment", admirer.subject == "flavor" {
            return " liked and commented your flavor:\n\(admirer.flavorHeader?.uppercased() ?? "")"
        }

        if admirer.type == "like", admirer.subject == "flavor" {
            return " liked your flavor:\n\(admirer.flavorHeader?.uppercased() ?? "")"
        }

        return ""
    }

    private func subtitleText(for admirer: Admirer) -> String? {
        if admirer.type == "comment", admirer.subject == "flavor" {
            return admirer.flavorComment
        }

        if admirer.type == "comment",
           (admirer.subject == "photo" || admirer.subject == "story") {
            return admirer.photoComment
        }

        return nil
    }
    
}

#Preview {
    AdmirersView()
}
