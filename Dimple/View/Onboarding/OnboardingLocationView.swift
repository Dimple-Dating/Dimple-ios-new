//
//  OnboardingLocationView.swift
//  Dimple
//
//  Created by Adrian Topka on 11/11/2024.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

final class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
    @Published var latitude: Double?
    @Published var longitude: Double?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        // Sprawdzamy status autoryzacji
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        @unknown default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            print("User denied location permissions.")
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
    }
}



struct OnboardingLocationView: View {
    
    @Bindable var viewModel: OnboardingViewModel
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Spacer()
            
            Text("ENABLE\nLOCATION")
                .font(.avenir(style: .medium, size: 32))
                .padding(.bottom)
            
            Text("Enable your location in order to use Dimple.\nIt will be used to show potential matches near you.\n\nWant to meet other Dimplers? Use our Passport option to discover the kindest community nation wide.")
                .font(.avenir(style: .regular, size: 14))
                .lineSpacing(3)
                .padding(.trailing, 48)
            
            Spacer()
            
            Spacer()
            
            OnboardingActionButton(title: "allow location") {
                viewModel.step = .rate
            }
            .hSpacing(.trailing)
            .padding(.bottom, 32)
        }
        .padding(32)
        .onAppear {
            viewModel.locationManager.requestLocation()
        }
        .onReceive(viewModel.locationManager.$latitude) { lat in
            if let lat = lat {
                viewModel.user.latitude = lat
            }
        }
        .onReceive(viewModel.locationManager.$longitude) { lon in
            if let lon = lon {
                viewModel.user.longitude = lon
            }
        }
       
    }
}
