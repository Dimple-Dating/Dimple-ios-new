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
            .font(.avenir(style: .regular, size: 15))
            .foregroundStyle(isSelected ? .black : .gray)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
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
