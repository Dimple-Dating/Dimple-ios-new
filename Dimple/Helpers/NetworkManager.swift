//
//  NetworkManager.swift
//  Dimple
//
//  Created by Adrian Topka on 08/11/2024.
//

import Foundation

final class NetworkManager {
    
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
}

enum RequestMethod: String {
    case POST
    case GET
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
