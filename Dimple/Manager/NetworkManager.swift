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

    func uploadPhoto(image: UIImage, photoOrder: Int) async throws -> (Data, URLResponse) {

        let localIdentifier = "\(UUID().uuidString)_new"

        var thumbnailData: Data?
        if let thumbnail = createThumbnail(from: image) {
            thumbnailData = thumbnail.jpegData(compressionQuality: 0.3)
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
