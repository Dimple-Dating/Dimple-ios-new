//
//  Numbers+Extensions.swift
//  Dimple
//
//  Created by Adrian Topka on 11/11/2024.
//

import Foundation

extension Double {
    var centimetersTofeetAndInch: String {
        let feet = self * 0.0328084
        let feetShow = Int(floor(feet))
        let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
        let inches = Int(floor(feetRest * 12))
        
        return "\(feetShow)’\(inches)"
    }
}
