//
//  GeocodeUseCaseImpl.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

struct GeocodeUseCaseImpl: GeocodeUseCase {
    
    typealias Input = String
    typealias Output = CLLocationCoordinate2D
    
    let geocodeDataService: GeocodeDataServiceImpl

    func execute(with input: String) async throws -> CLLocationCoordinate2D {
        try await geocodeDataService.execute(with: input)
    }
}
