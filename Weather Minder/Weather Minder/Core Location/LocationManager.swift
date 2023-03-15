//
//  LocationManager.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var currentLocation: CLLocation? {
        didSet {
            locationError = nil
        }
    }
    
    @Published var locationError: Error?

    override init() {
        super.init()
        
        setUpdates()
    }
    
    func setUpdates() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        locationError = error
    }
}

