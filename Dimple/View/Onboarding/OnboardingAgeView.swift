//
//  OnboardingAgeView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI
import UIKit
import Foundation

struct OnboardingAgeView: View {
    
    @Binding var viewModel: OnboardingViewModel
    
    @State private var m1: String = ""
    @State private var m2: String = ""
    @State private var d1: String = ""
    @State private var d2: String = ""
    @State private var y1: String = ""
    @State private var y2: String = ""
    @State private var y3: String = ""
    @State private var y4: String = ""
    
    enum FocusedField {
        case m1, m2, d1, d2, y1, y2, y3, y4
    }
    
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            birthdayField()
                .padding()

            Spacer()
            
            OnboardingActionButton() {
                
                if let selectedAge = getAge() {
                    viewModel.user.age = "\(selectedAge)"
                    viewModel.step = .prefGender
                }
                
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
            .padding(.bottom, 54)
            
        }
        .onboardingTemplate(title: "SET YOUR DATE OF BIRTH", progress: 0.45)
        
    }
    
    func birthdayField() -> some View {
        
        HStack {
            TextField("M", text: $m1)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .m1)
                .frame(width: 30)
                .onChange(of: m1) { old, new in
                    if m1.count > 0 {
                        m1 = "\(new.suffix(1))"
                        focusedField = .m2
                    }
                }
                
            
            TextField("M", text: $m2)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .m2)
                .onChange(of: m2) { old, new in
                    if m2.count > 0 {
                        m2 = "\(new.suffix(1))"
                        focusedField = .d1
                    }
                }
                .frame(width: 30)
            
            Text("/")
            
            TextField("D", text: $d1)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .d1)
                .onChange(of: d1) { old, new in
                    if d1.count > 0 {
                        d1 = "\(new.suffix(1))"
                        focusedField = .d2
                    }
                }
                .frame(width: 30)
            
            TextField("D", text: $d2)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .d2)
                .onChange(of: d2) { old, new in
                    if d2.count > 0 {
                        d2 = "\(new.suffix(1))"
                        focusedField = .y1
                    }
                }
                .frame(width: 30)
            
            Text("/")
            
            TextField("Y", text: $y1)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .y1)
                .onChange(of: y1) { old, new in
                    if y1.count > 0 {
                        y1 = "\(new.suffix(1))"
                        focusedField = .y2
                    }
                }
                .frame(width: 30)
            
            TextField("Y", text: $y2)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .y2)
                .onChange(of: y2) { old, new in
                    if y2.count > 0 {
                        y2 = "\(new.suffix(1))"
                        focusedField = .y3
                    }
                }
                .frame(width: 30)
            
            TextField("Y", text: $y3)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .y3)
                .onChange(of: y3) { old, new in
                    if y3.count > 0 {
                        y3 = "\(new.suffix(1))"
                        focusedField = .y4
                    }
                }
                .frame(width: 30)
            
            TextField("Y", text: $y4)
                .multilineTextAlignment(.center)
                .focused($focusedField, equals: .y4)
                .onChange(of: y4) { old, new in
                    if y4.count > 0 {
                        y4 = "\(new.suffix(1))"
                    }
                }
                .frame(width: 30)
        }
        .font(.avenir(style: .medium, size: 24))
        .keyboardType(.numberPad)
        
    }
    
    func getAge() -> Int? {
        
        let month = m1 + m2
        let day = d1 + d2
        let year = y1 + y2 + y3 + y4

        guard let monthInt = Int(month), let dayInt = Int(day), let yearInt = Int(year) else {
            return nil
        }

        let calendar = Calendar.current
        let now = Date()
        var components = DateComponents()
        components.year = yearInt
        components.month = monthInt
        components.day = dayInt

        guard let birthDate = calendar.date(from: components) else {
            return nil
        }

        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year
    }

}

#Preview {
    OnboardingAgeView(viewModel: .constant(.init()))
}
