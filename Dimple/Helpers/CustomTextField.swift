//
//  CustomTextField.swift
//  Dimple
//
//  Created by Adrian Topka on 21/08/2024.
//

import SwiftUI

struct CustomTextField: View {
    
    var placeholder: String
    
    @Binding var value: String
    
    @Binding var showIsRequired: Bool
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var hasValue: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(placeholder)
                .font(.avenir(style: .regular, size: 16))
                .foregroundStyle(.gray)
                .opacity(hasValue ? 1 : 0)
                .offset(y: hasValue ? 0 : 30)
                .animation(.easeIn(duration: 0.3), value: hasValue)
            
            TextField(placeholder, text: $value)
                .font(.avenir(style: .regular, size: 14))
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) {
                    if isTextFieldFocused {
                        hasValue = true
                    } else {
                        hasValue = value.count > 0
                    }
                }
                
            
            Rectangle()
                .foregroundStyle(showIsRequired ? .red : .black)
                .frame(height: 0.7)
            
            if showIsRequired {
                Text("This field is required")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            
            Spacer()
            
        }
        .frame(height: 80)
        
    }
    
}
#Preview {
    CustomTextField(placeholder: "Your name", value: .constant("dasda"), showIsRequired: .constant(true))
}
