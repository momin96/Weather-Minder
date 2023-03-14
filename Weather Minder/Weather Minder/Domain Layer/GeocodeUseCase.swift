//
//  GeoCoderUseCase.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

// Domain layer
protocol GeocodeUseCase {
    func execute(with city: String) async throws -> CLLocationCoordinate2D
}

struct GeocodeUseCaseImpl: GeocodeUseCase {
    let geocodeDataService: GeocodeDataService
    
    func execute(with city: String) async throws -> CLLocationCoordinate2D {
        try await geocodeDataService.geocode(with: city)
    }
}

protocol ReverseGeocodeUseCase {
    func execute(with coordinates: CLLocationCoordinate2D) async throws -> String
}

struct ReverseGeocodeUseCaseImpl: ReverseGeocodeUseCase {
    
    let reverseGeocodeDataService: ReverseGeocodeDataService
    
    func execute(with coordinates: CLLocationCoordinate2D) async throws -> String {
        try await reverseGeocodeDataService.reverseGeocode(with: coordinates)
    }
}
