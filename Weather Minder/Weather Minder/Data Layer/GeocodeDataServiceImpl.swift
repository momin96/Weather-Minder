//
//  GeocodeDataServiceImpl.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

struct GeocodeDataServiceImpl: Geocodable {
    
    typealias Input = String
    typealias Output = CLLocationCoordinate2D

    func execute(with input: String) async throws -> CLLocationCoordinate2D {
        
        let placemarks = try await geocoder.geocodeAddressString(input)
        
        guard let placemark = placemarks.first,
              let location = placemark.location else {
            throw geocoderError
        }
        
        return location.coordinate
    }
}
