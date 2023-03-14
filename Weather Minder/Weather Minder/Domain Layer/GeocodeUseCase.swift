//
//  GeoCoderUseCase.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

// Domain layer
protocol GeocodeUseCase {
    associatedtype Input
    associatedtype Output
    func execute(with input: Input) async throws -> Output
}

struct GeocodeUseCaseImpl: GeocodeUseCase {
    typealias Input = String
    typealias Output = CLLocationCoordinate2D
    
    let geocodeDataService: GeocodeDataService

    func execute(with input: String) async throws -> CLLocationCoordinate2D {
        try await geocodeDataService.geocode(with: input)
    }
}

struct ReverseGeocodeUseCaseImpl: GeocodeUseCase {
    typealias Input = CLLocationCoordinate2D
    typealias Output = String
    
    let reverseGeocodeDataService: ReverseGeocodeDataService
    
    func execute(with coordinates: CLLocationCoordinate2D) async throws -> String {
        try await reverseGeocodeDataService.reverseGeocode(with: coordinates)
    }
}
