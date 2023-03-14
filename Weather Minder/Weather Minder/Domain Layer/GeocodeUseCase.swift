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
        return try await geocodeDataService.geocode(with: city)
    }
}
