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
    
    static let shared = NetworkManager()
    
    private init() {}

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
    
    func fetchResponse(urlString: String, method: RequestMethod, body: [String: Any]? = nil) async throws -> (Data, URLResponse) {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
       
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
   
        if let body = body {
            print("wysyłam body = \(body)")
            request.httpBody = body.convertToData()
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }

        request.setValue("Bearer \(appToken)", forHTTPHeaderField: "Authorization")
        
        print("=== \(appToken)")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed
        }

        return (data, response)
    }

    func uploadPhoto(image: UIImage, isInstagram: Bool = false) async throws -> (Data, URLResponse) {
//        guard let photoOrder = photo.orderNumber.value,
//              let localIdentifier = photo.localIdentifier else { return }
        
        let photoOrder = 1
        let localIdentifier = UUID().uuidString

        // Tworzenie miniatury bez zapisywania jej do dysku
        var thumbnailData: Data?
//        if let thumbnail = createThumbnail(from: image) {
//            thumbnailData = thumbnail.jpegData(compressionQuality: 0.3)
//        }

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

        // Wykonaj żądanie
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
    case requestFailed
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
