//
//  CustomSelectionButton.swift
//  Dimple
//
//  Created by Adrian Topka on 05/11/2024.
//

import SwiftUI

struct CustomSelectionButton: View {
    
    var text: String
    
    @Binding var isSelected: Bool
    
    var body: some View {
        
        Text(text)
            .foregroundStyle(isSelected ? .black : .gray)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .overlay {
                Capsule()
                    .stroke(lineWidth: 1)
                    .foregroundStyle(isSelected ? .black : .gray)
            }
            .padding(.bottom, 24)
        
        
    }
}

#Preview {
    VStack {
        CustomSelectionButton(text: "Male", isSelected: .constant(true))
        CustomSelectionButton(text: "Female", isSelected: .constant(false))
    }
}
