//
//  GeocodeDataService.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

protocol Geocodable {
    var geocoder: CLGeocoder { get set }
}

// Data layer
protocol GeocodeDataService: Geocodable {
    func geocode(with city: String) async throws -> CLLocationCoordinate2D
}

struct GeocodeDataServiceImpl: GeocodeDataService {
    var geocoder = CLGeocoder()

    func geocode(with city: String) async throws -> CLLocationCoordinate2D {
        let placemarks = try await geocoder.geocodeAddressString(city)
        guard let placemark = placemarks.first,
              let location = placemark.location else {
            throw NSError(domain: "app.web.nasirmomin.geocoding",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to geocode city"])
        }
        
        return location.coordinate
    }
}


protocol ReverseGeocodeDataService: Geocodable {
    func reverseGeocode(with coordinate: CLLocationCoordinate2D) async throws -> String
}

struct ReverseGeocodeDataServiceImpl: ReverseGeocodeDataService {
    var geocoder = CLGeocoder()
    
    func reverseGeocode(with coordinate: CLLocationCoordinate2D) async throws -> String {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        guard let placemark = placemarks.first,
              let cityName = placemark.name else {
            throw NSError(domain: "app.web.nasirmomin.geocoding",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to Reverse geocode to give coordinates"])
        }
        return cityName
    }
}
