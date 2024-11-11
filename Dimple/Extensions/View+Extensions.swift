//
//  View+Extensions.swift
//  Dimple
//
//  Created by Adrian on 20/08/2024.
//

import SwiftUI

extension View {
    
    /// Custom Spacers
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// Checking two dates are the same
    func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
}

extension Font {
    
    enum Avenir: String {
        
        case regular = "Avenir Next"
        case medium = "Avenir Next Medium"
        case demiBold = "Avenir Next Demi Bold"
        case bold = "Avenir Next Bold"
        
    }
    
    static func avenir(style: Avenir, size: CGFloat) -> Font {
        return .custom(style.rawValue, size: size)
    }
    
}

