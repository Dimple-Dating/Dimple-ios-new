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
    
    @State private var isTyping: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(placeholder)
                .foregroundStyle(.gray)
                .opacity(isTyping ? 1 : 0)
                .offset(y: isTyping ? 0 : 30)
                .animation(.easeIn(duration: 0.3), value: isTyping)
            
            TextField(placeholder, text: $value)
                .onChange(of: value) {
                    isTyping = value.count > 0
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
