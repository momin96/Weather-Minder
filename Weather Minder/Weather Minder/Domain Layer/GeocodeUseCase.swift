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
    
    let geocodeDataService: GeocodeDataServiceImpl

    func execute(with input: String) async throws -> CLLocationCoordinate2D {
        try await geocodeDataService.execute(with: input)
    }
}

struct ReverseGeocodeUseCaseImpl: GeocodeUseCase {
    typealias Input = CLLocationCoordinate2D
    typealias Output = String
    
    let reverseGeocodeDataService: ReverseGeocodeDataServiceImpl
    
    func execute(with input: CLLocationCoordinate2D) async throws -> String {
        try await reverseGeocodeDataService.execute(with: input)
    }
}
