//
//  SchoolSearchView.swift
//  Dimple
//
//  Created by Adrian Topka on 16/12/2024.
//

import SwiftUI
import GooglePlaces

struct SchoolSearchView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Bindable var model: SearchSchoolViewModel
    
    @State private var searchText: String = ""
    
    var body: some View {
    
        VStack {
            
            Text("Choose school".uppercased())
                .font(.avenir(style: .medium, size: 18))
                .kerning(1.44)
                .padding(.top)
            
            NavigationStack {
                
                if model.results.isEmpty {
                    Text(searchText)
                        .hSpacing(.leading)
                        .padding()
                        .padding(.leading, 8)
                    Spacer()
                } else {
                    VStack {
                        ForEach(model.results, id: \.placeID) { place in
                            Text(place.attributedFullText.string)
                                .font(.avenir(style: .regular, size: 15))
                                .kerning(1.2)
                                .hSpacing(.leading)
                                .padding([.bottom, .horizontal])
                                .padding(.leading, 8)
                                .onTapGesture {
                                    self.model.addSchool(place)
                                    self.dismiss()
                                }
                            
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 24)
                }
                
            }
            .tint(.black)
            .searchable(text: $searchText, isPresented: .constant(true), prompt: "Search by school")
            .onChange(of: searchText) {
                if searchText.count > 2 {
                    model.search(text: searchText)
                }
            }
        }
        .onDisappear {
            model.results = []
        }
    }
}

#Preview {
    SchoolSearchView(model: .init())
}

@Observable
class SearchSchoolViewModel {
    
    private var client: GMSPlacesClient
    
    var results: [GMSAutocompletePrediction] = []
    
    var selectedSchools: [GMSAutocompletePrediction] = []
    
    init() {
        GMSPlacesClient.provideAPIKey("AIzaSyALQxbJmBxnhh8B4KvHJcR5Vn-qbl9iyVc")
        self.client = .init()
    }
    
    func search(text: String) {
        
        let token = GMSAutocompleteSessionToken()
        let biastCoords = CLLocationCoordinate2D(latitude: 52.229676, longitude: 21.012229)
        
        let filter = GMSAutocompleteFilter()
        filter.types = [kGMSPlaceTypeSchool, kGMSPlaceTypeUniversity, kGMSPlaceTypeSecondarySchool]
        filter.locationBias = GMSPlaceRectangularLocationOption(biastCoords, biastCoords)
//        filter.countries = ["US"]
        
        client.findAutocompletePredictions(fromQuery: text, filter: filter, sessionToken: token) { results, error in
            if let error = error {
                print("Autocomplete error: \(error)")
                return
            }
            
            self.results = results ?? []
            print(results?.forEach({print("\($0.attributedFullText)")}) ?? "dupa")
            
        }
        
    }
    
    func addSchool(_ school: GMSAutocompletePrediction) {
        self.selectedSchools.append(school)
    }
    
    func removeSchool(_ school: GMSAutocompletePrediction) {
        self.selectedSchools.removeAll(where: {$0.placeID == school.placeID})
    }
}
