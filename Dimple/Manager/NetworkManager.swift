//
//  NetworkManager.swift
//  Dimple
//
//  Created by Adrian Topka on 08/11/2024.
//

import SwiftUI
import Foundation

final class NetworkManager {
    
    @AppStorage("token") var appToken: String = ""
    @AppStorage("refreshToken") var refreshToken: String = ""
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func sendRequest(urlString: String, method: RequestMethod, body: [String: Any]? = nil, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = body.convertToData()
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                } else {
                    completion(.failure(NetworkError.decodingError))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    
    

    func fetch<T: Codable>(urlString: String, method: RequestMethod, body: [String: Any]? = nil) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = body.convertToData()
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Error")
            throw NetworkError.requestFailed
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            print("===== \(decodedData)")
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func request(_ urlPath: APIRoute, queryParameters: [String: Any]? = nil, method: RequestMethod, body: [String: Any]? = nil) async throws -> (Data, URLResponse) {
        
        var path = "https://api.dimple.dating/v1" + urlPath.path
        
        if let queryParameters = queryParameters {
            let queryString = queryParameters.map { key, value in
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "\(value)"
                return "\(encodedKey)=\(encodedValue)"
            }.joined(separator: "&")
            
            path += "?\(queryString)"
        }
        
        // Function to create request with current configuration
        func createConfiguredRequest() throws -> URLRequest {
            guard let url = URL(string: path) else {
                throw NetworkError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            if let body = body {
                request.httpBody = body.convertToData()
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
            
            request.setValue("Bearer \(appToken)", forHTTPHeaderField: "Authorization")
            
            return request
        }
        
        var request = try createConfiguredRequest()
        var (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            
            let refreshSuccess = try await refreshToken()
            if refreshSuccess {
                request = try createConfiguredRequest()
                (data, response) = try await URLSession.shared.data(for: request)
            } else {
                throw NetworkError.authFailed
            }
        }
        
        // Final response validation
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed
        }

        return (data, response)
    }

    func uploadPhoto(image: UIImage, photoOrder: Int) async throws -> (Data, URLResponse) {

        let localIdentifier = "\(UUID().uuidString)_new"

        var thumbnailData: Data?
        if let thumbnailData = createThumbnail(from: image)?.jpegData(compressionQuality: 0.3) {
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: URL(string: "https://api.dimple.dating/v1/upload/photo")!)
        request.httpMethod = RequestMethod.POST.rawValue
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Dodaj miniaturę jeśli istnieje
        if let thumbnailData = thumbnailData {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"thumbnail\"; filename=\"thumbnail.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(thumbnailData)
            body.append("\r\n")
        }

        // Dodaj obraz bezpośrednio jako dane
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }

        // Dodaj photoOrder
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"photoOrder\"\r\n\r\n")
        body.append("\(photoOrder)")
        body.append("\r\n")

        // Dodaj localIdentifier
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"localIdentifier\"\r\n\r\n")
        body.append(localIdentifier)
        body.append("\r\n")

        // Zakończ boundary
        body.append("--\(boundary)--\r\n")

        request.httpBody = body
        request.setValue("Bearer \(appToken)", forHTTPHeaderField: "Authorization")
        
        print("==== indentifier = \(localIdentifier)")

        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code:", httpResponse.statusCode)
            print("Headers:", httpResponse.allHeaderFields)
        }
        
        return (data, response)

        // Obsłuż odpowiedź
//        do {
//            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                if let remoteID = jsonObject["imageId"] as? Int {
//                    self.updatePhotoRemoteID(photo: photo, remoteID: remoteID)
//                    print("remoteID: ", remoteID)
//                }
//            }
//        } catch {
//            print("Failed to parse JSON:", error)
//        }
    }
    
    private func createThumbnail(from image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage,
              let colorSpace = cgImage.colorSpace else { return nil }

        let width = Int(image.size.width * 0.2)
        let height = Int(image.size.height * 0.2)
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let bitmapInfo = cgImage.bitmapInfo

        guard let context = CGContext(data: nil, width: width, height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow, space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else { return nil }
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
        context.draw(cgImage, in: rect)
        return context.makeImage().flatMap { UIImage(cgImage: $0) }
    }

    
    private func refreshToken() async throws -> (Bool) {
    
        if refreshToken.isEmpty {
            throw NetworkError.authFailed
        }
        
        let body = ["refreshToken": refreshToken]
        
        var path = "https://api.dimple.dating/v1" + APIRoute.refreshToken.path
        
        guard let url = URL(string: path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = RequestMethod.POST.rawValue
        request.httpBody = body.convertToData()
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let token = jsonObject["token"] as? String,
               let refreshToken = jsonObject["refresh_token"] as? String {
                self.appToken = token
                self.refreshToken = refreshToken
                return true
            }
            return false
            
        } catch {
            throw NetworkError.authFailed
        }
        
    }
    
}

enum RequestMethod: String {
    case POST
    case GET
    case PUT
    case UPDATE
    case DELETE
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case requestFailed
    case authFailed
    case decodingError
    case unknown
}


extension Dictionary where Key == String {
    func convertToData() -> Data {
        let jsonString = self.reduce("") { "\($0)\($1.0)=\($1.1)&" }
        let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)!
        return jsonData
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

enum APIRoute {
    
    // MARK: Cases
    
    case getUserList
    case likeProfile
    case likePhoto(photoId: Int)
    case commentPhoto
    case likeFlavor
    case likeStory
    case likeMatchStory
    case commentMatchStory
    case commentFlavor
    case commentStory
    
    case videochatPing
    case getVideochatPartner
    case disconnectVideochat
    
    case blockUser(userID: String)
    case reportUser(userID: String)
    case dismissSwipeUser(userID: String)

    case deleteMatchesAndBlockedUsers
    
    case savePushToken
    case getVoxImplantUser
    
    case getUserProfile
    case getUserProfileByID(userID: String)
    case deleteProfile
    
    case updateUser
    case uploadChatPhoto
    case uploadPhoto
    case updatePhoto(photoId: String)
    case updateAvatar(photoId: String)
    case deletePhoto(photoId: String)
    
    case getFlavors
    case createFlavor
    case updateFlavor
    case deleteFlavor(id: String)
    
    case getPreferences
    case createPreference
    case updatePreferences

    case getNotificationBadgesCounts(userId: String)
    
    case refreshToken
    
    var path: String {
        switch self {
        case .disconnectVideochat:
            return "/voximplant/disconnect"
        case .videochatPing:
            return "/voximplant/ping"
        case .getUserList:
            return "/users/list"
        case .getVideochatPartner:
            return "/voximplant/match"
        case .likeProfile:
            return "/user/like/profile"
        case .likePhoto(let photoId):
            return "/rate/image/\(photoId)"
        case .commentPhoto, .commentStory:
            return "/user-photo/comments"
        case .likeFlavor:
            return "/user-photo/like/flavor"
        case .likeStory:
            return "/user/like/story"
        case .likeMatchStory:
            return "/user/like/story/matched"
        case .commentMatchStory:
            return "/user/comment/story/matched"
        case .commentFlavor:
            return "/user-photo/comments/flavor"
        case .blockUser(let userID):
            return "/users/\(userID)/status/3" // 3 means "Blocked & Report"
        case .reportUser(let userID):
            return "/users/\(userID)/status/2" // 2 means "Report"
        case .dismissSwipeUser(let userID):
            return "/users/\(userID)/status/4" // 4 means "Blocked on user list"
        case .deleteMatchesAndBlockedUsers:
            return "/user/delete-matching"
        case .savePushToken:
            return "/devicetoken/save"
        case .getVoxImplantUser:
            return "/voximplant/getUser"
        case .getUserProfile:
            return "/user/profile"
        case .getUserProfileByID(let userID):
            return "/user/profile/\(userID)"
        case .getFlavors:
            return "/user/getflavours"
        case .updateUser:
            return "/user/update"
        case .uploadChatPhoto:
            return "/upload/photo/chat"
        case .uploadPhoto:
            return "/upload/photo"
        case .updatePhoto(let photoId):
            return "photo/preference/\(photoId)"
        case .updateAvatar(let photoId):
            return "user/avatar/\(photoId)"
        case .deletePhoto(let photoId):
            return "/user-photo/delete/" + photoId
        case .createFlavor:
            return "/user/flavour/add"
        case .getPreferences, .createPreference, .updatePreferences:
            return "/user/preference"
        case .deleteFlavor(let id):
            return "/user/flavour/delete/\(id)"
        case .updateFlavor:
            return "/user/flavour/update"
        case .deleteProfile:
            return "/user"
        case .getNotificationBadgesCounts(let userId):
            return "/user/badges/\(userId)"
        case .refreshToken:
            return "/auth/refreshToken"
        }
    }
    
}
