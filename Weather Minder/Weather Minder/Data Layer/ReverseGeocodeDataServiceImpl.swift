//
//  ReverseGeocodeDataServiceImpl.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

struct ReverseGeocodeDataServiceImpl: Geocodable {
    
    typealias Input = CLLocationCoordinate2D
    typealias Output = String

    func execute(with input: CLLocationCoordinate2D) async throws -> String {
        
        let location = CLLocation(
            latitude: input.latitude,
            longitude: input.longitude
        )
        
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        
        guard let placemark = placemarks.first,
              let cityName = placemark.name else {
            throw geocoderError
        }
        
        return cityName
    }
}
