//
//  GeocodeDataService.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

// Data layer
protocol GeocodeDataService {
    func geocode(with city: String) async throws -> CLLocationCoordinate2D
}

struct GeocodeDataServiceImpl: GeocodeDataService {
    private let geocoder = CLGeocoder()

    func geocode(with city: String) async throws -> CLLocationCoordinate2D {
        let geocoder = CLGeocoder()
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
