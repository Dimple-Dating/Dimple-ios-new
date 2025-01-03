//
//  OnboardingSchoolView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/12/2024.
//

import SwiftUI

struct OnboardingSchoolView: View {
    
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        
        VStack {
            
            Text("only if you want - it's optional")
                .font(.avenir(style: .regular, size: 12))
                .hSpacing(.leading)
                .padding(.leading, 32)
                .padding(.top, -6)
            
            VStack(alignment: .leading, spacing: 6) {
                
                ForEach(viewModel.schoolsManager.selectedSchools, id: \.placeID) { place in
                    
                    HStack {
                        
                        Text(place.attributedPrimaryText.string)
                            .font(.avenir(style: .regular, size: 14))
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Button {
                            self.viewModel.schoolsManager.removeSchool(place)
                        } label: {
                            Image(systemName: "multiply")
                                .foregroundStyle(.black)
                        }

                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black)
                        .padding(.bottom, 22)
                    
                }
                
                Text("Your school name")
                    .font(.avenir(style: .regular, size: 14))
                    .foregroundStyle(.gray)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.black)
                
            }
            .onTapGesture {
                viewModel.isSchoolSearchViewPresented = true
            }
            .padding(.top, 32)
            .padding(.leading, 32)
            .padding(.trailing, 80)
            
            
            Button {
                viewModel.isSchoolSearchViewPresented = true
            } label: {
                Text("+ Add another school")
                    .font(.avenir(style: .medium, size: 12))
                    .foregroundStyle(.black)
            }
            .hSpacing(.leading)
            .padding(.leading, 32)
            .padding(.top, 36)

            Spacer()
            
            OnboardingActionButton() {
                self.viewModel.step = .gallery
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
            .padding(.bottom, 54)
            
        }
        .onboardingTemplate(title: "SCHOOLS YOU\nATTEND/ATTENDED", progress: 0.75)
        
    }
}

#Preview {
    OnboardingSchoolView(viewModel: .init())
}
