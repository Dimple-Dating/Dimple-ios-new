//
//  OnboardingAgeView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/11/2024.
//

import SwiftUI

struct OnboardingAgeView: View {
    
    @Bindable var viewModel: OnboardingViewModel
    
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    @State private var showAlert = false
    @State private var age: Int = 18
    
    var body: some View {
        
        VStack(spacing: 0) {
            Form {
                DatePicker("", 
                           selection: $birthDate,
                           in: ...Calendar.current.date(byAdding: .year, value: -18, to: Date())!,
                           displayedComponents: .date)
                    .datePickerStyle(.wheel)
            }
            .background(.white)
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            Spacer()
            
            OnboardingActionButton() {
                age = getAge()
                showAlert = true
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
            .padding(.bottom, 54)
            
        }
        .onboardingTemplate(title: "SET YOUR DATE OF BIRTH", progress: 0.45)
        .alert("Please confirm your age is \(age)", isPresented: $showAlert) {
            Button("Yes") {
                viewModel.user.age = "\(age)"
                viewModel.step = .prefGender
            }
            
            Button("No", role: .cancel) {
                
            }
            
        }
        
    }
        
        
    func getAge() -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
    }
    
}
    

#Preview {
    OnboardingAgeView(viewModel: .init())
}
