//
//  OnboardingSchoolView.swift
//  Dimple
//
//  Created by Adrian Topka on 07/12/2024.
//

import SwiftUI

struct OnboardingSchoolView: View {
    
    @Binding var viewModel: OnboardingViewModel
    
    @State private var showSearchView: Bool = false
    
    var searchModel: SearchSchoolViewModel = .init()
    
    var body: some View {
        
        VStack {
            
            Text("only if you want - it's optional")
                .font(.avenir(style: .regular, size: 12))
                .hSpacing(.leading)
                .padding(.leading, 32)
                .padding(.top, -6)
            
            VStack(alignment: .leading, spacing: 6) {
                
                ForEach(searchModel.selectedSchools, id: \.placeID) { place in
                    
                    HStack {
                        
                        Text(place.attributedPrimaryText.string)
                            .font(.avenir(style: .regular, size: 14))
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Button {
                            self.searchModel.removeSchool(place)
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
                self.showSearchView = true
            }
            .padding(.top, 32)
            .padding(.leading, 32)
            .padding(.trailing, 80)
            
            
            Button {
                self.showSearchView = true
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
                
            }
            .hSpacing(.trailing)
            .padding(.trailing, 32)
            .padding(.bottom, 54)
            
        }
        .onboardingTemplate(title: "SCHOOLS YOU\nATTEND/ATTENDED", progress: 0.75)
        .sheet(isPresented: $showSearchView) {
            SchoolSearchView(model: searchModel)
        }
    }
}

#Preview {
    OnboardingSchoolView(viewModel: .constant(.init()))
}
