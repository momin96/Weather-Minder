//
//  ReverseGeocodeUseCaseImpl.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

struct ReverseGeocodeUseCaseImpl: GeocodeUseCase {
    
    typealias Input = CLLocationCoordinate2D
    typealias Output = String
    
    let reverseGeocodeDataService: ReverseGeocodeDataServiceImpl
    
    func execute(with input: CLLocationCoordinate2D) async throws -> String {
        try await reverseGeocodeDataService.execute(with: input)
    }
}
