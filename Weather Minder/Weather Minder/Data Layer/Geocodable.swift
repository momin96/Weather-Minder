//
//  Geocodable.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

// Data layer
protocol Geocodable {
    associatedtype Input
    associatedtype Output
    
    func execute(with input: Input) async throws -> Output
}

extension Geocodable {
    var geocoder: CLGeocoder { CLGeocoder() }
    
    var geocoderError: NSError {
        NSError(domain: "app.web.nasirmomin.geocoderError",
                      code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Unable to geocode \(Input.self)"])
    }
}
