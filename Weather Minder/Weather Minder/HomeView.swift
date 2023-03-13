//
//  HomeView.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import CoreLocation
import SwiftUI

struct HomeView: View {
    @State var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            ContentView()
            viewModel.currentLocation.map { location in
                HStack {
                    Text("\(location.coordinate.latitude)")
                    Text("  \(location.coordinate.longitude)")

                }
            }
        }
    }
}

class HomeViewModel: NSObject  {
    
    let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation? = nil
    
    override init() {
        super.init()
        // Request authorization from the user
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
}

// Implement the CLLocationManagerDelegate protocol
extension HomeViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Update the user's location
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle errors here
        print(error.localizedDescription)
    }
}
