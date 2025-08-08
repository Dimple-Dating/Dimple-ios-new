//
//  AdmirersViewModel.swift
//  Dimple
//
//  Created by Adrian Topka on 08/08/2025.
//

import SwiftUI
import Foundation

@Observable
class AdmirersViewModel {
    
    var admirers: [Admirer] = []
    
    func fetchAdmirers() async {
        do {
            let (rawData, _) = try await NetworkManager.shared.request(.getNotifications, method: .GET)
            self.admirers = try JSONDecoder().decode([Admirer].self, from: rawData)
            print("Admirers decoded: ", admirers.count)
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
}


/// Model powiadomienia push w wersji `Codable`
final class Admirer: Codable {

    // MARK: - Public properties (takie same jak w poprzednim modelu)
    var id: Int?
    var type: String?
    var subject: String?

    // Dane użytkownika, który polubił / skomentował
    var userID: Int?
    var username: String?
    var userAvatarPath: String?
    var userHaveStories: Bool = false

//    // Dane dotyczące zalogowanego użytkownika
    var likedPhotoId: Int?
    var likedPhotoPath: String?
    var photoComment: String?
    var isReaded: Bool = false
//
//    // Dane flavour
    var flavorHeader: String?
    var flavorComment: String?
    var flavorContent: String?

    // MARK: - CodingKeys (tylko klucze z pierwszego poziomu)
    //
    // Klucze zagnieżdżone obsłużymy w kodzie poprzez nested container
    private enum CodingKeys: String, CodingKey {
        case id
        case type          = "wink_type"
        case subject       = "wink_subject"
        case mainUser      = "main_user"
        case userPhoto     = "user_photo"
        case photoComment  = "photo_comment"
        case flavorComment = "flavor_comment"
        case flavor        = "flavor"
        case isReaded      = "is_readed"
    }

    // MARK: - Nested key enums
    private enum MainUserKeys: String, CodingKey {
        case id
        case fullName      = "full_name"
        case avatar
        case isHaveStories = "is_have_stories"
    }

    private enum AvatarKeys: String, CodingKey { case fullPath = "full_path" }

    private enum UserPhotoKeys: String, CodingKey {
        case id
        case image
    }

    private enum ImageKeys: String, CodingKey { case fullPath = "full_path" }

    private enum CommentKeys: String, CodingKey {
        case comment
        case flavor
    }

    private enum FlavorKeys: String, CodingKey {
        case header
        case content
    }

    // MARK: - Initializers

    /// Niestandardowy initializer `Decodable`
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Proste pola
        id       = try container.decodeIfPresent(Int.self, forKey: .id)
        type     = try container.decodeIfPresent(String.self, forKey: .type)
        subject  = try container.decodeIfPresent(String.self, forKey: .subject)
        isReaded = try container.decodeIfPresent(Bool.self,    forKey: .isReaded) ?? false

        // MARK: main_user.*
        if container.contains(.mainUser) {
            let main = try container.nestedContainer(keyedBy: MainUserKeys.self, forKey: .mainUser)

            userID          = try main.decodeIfPresent(Int.self, forKey: .id)
            username        = try main.decodeIfPresent(String.self, forKey: .fullName)
            userHaveStories = try main.decodeIfPresent(Bool.self,   forKey: .isHaveStories) ?? false

            if main.contains(.avatar) {
                let avatar = try main.nestedContainer(keyedBy: AvatarKeys.self, forKey: .avatar)
                userAvatarPath = try avatar.decodeIfPresent(String.self, forKey: .fullPath)
            }
        }

        // MARK: user_photo.*
        if container.contains(.userPhoto) {
            let photo = try container.nestedContainer(keyedBy: UserPhotoKeys.self, forKey: .userPhoto)
            likedPhotoId = try photo.decodeIfPresent(Int.self, forKey: .id)

            if photo.contains(.image) {
                let image = try photo.nestedContainer(keyedBy: ImageKeys.self, forKey: .image)
                likedPhotoPath = try image.decodeIfPresent(String.self, forKey: .fullPath)
            }
        }

        // MARK: Komentarz zdjęcia
        if let photoCommentContainer = try? container.nestedContainer(keyedBy: CommentKeys.self, forKey: .photoComment) {
            photoComment = try photoCommentContainer.decodeIfPresent(String.self, forKey: .comment)
        }

        // FLAVOR COMMENT
        if let flavCommentContainer = try? container.nestedContainer(keyedBy: CommentKeys.self, forKey: .flavorComment) {
            flavorComment = try flavCommentContainer.decodeIfPresent(String.self, forKey: .comment)

            if let flavSub = try? flavCommentContainer.nestedContainer(keyedBy: FlavorKeys.self, forKey: .flavor) {
                flavorHeader  = try flavSub.decodeIfPresent(String.self, forKey: .header)
                flavorContent = try flavSub.decodeIfPresent(String.self, forKey: .content)
            }
        }

        // FALLBACK TO ROOT FLAVOR
        if flavorHeader == nil,
           let flav = try? container.nestedContainer(keyedBy: FlavorKeys.self, forKey: .flavor) {
            flavorHeader  = try flav.decodeIfPresent(String.self, forKey: .header)
            flavorContent = try flav.decodeIfPresent(String.self, forKey: .content)
        }

        // MARK: Cache obrazów (ta logika była w oryginale)
//        if let avatarPath = userAvatarPath {
//            Photo.saveImageToCache(path: avatarPath)
//        }
//        if let likedPath = likedPhotoPath {
//            Photo.saveImageToCache(path: likedPath)
//        }
    }

    // MARK: - Encodable (
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(id,      forKey: .id)
        try container.encodeIfPresent(type,    forKey: .type)
        try container.encodeIfPresent(subject, forKey: .subject)
//        try container.encode(isReaded,         forKey: .isReaded)

        // (analogicznie do części dekodującej).
    }
}
