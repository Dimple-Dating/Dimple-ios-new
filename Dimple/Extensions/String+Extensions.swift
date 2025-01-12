//
//  String+Extensions.swift
//  Dimple
//
//  Created by Adrian Topka on 11/11/2024.
//

import Foundation

extension String {
    
    func convertToMeters() -> Float {
        let theConvertion = self.components(separatedBy: "’")
        
        let value = theConvertion[safe: 0] ?? "0"
        let value2 = theConvertion[safe: 1] ?? "0"
        
        if let value = Int(value), let value2 = Int(value2) {
            let number = Float((value * 12) + value2) * 2.54;
            return round(number * 100.0) / 100.0
        }
        
        return 0
    }

    // For Preferences mainly
    func toArray() -> [String] {
        return self
            .components(separatedBy: ",")
            .compactMap { $0.trimmingCharacters(in: .whitespaces) }
    }

}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
