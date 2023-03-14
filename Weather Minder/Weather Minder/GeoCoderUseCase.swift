//
//  GeoCoderUseCase.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

struct GeoCoderUseCase {
    
    let geocoder = CLGeocoder()

//
//    func geo(_ cities: [String]) async -> any AsyncSequence {
//        for city in cities {
//            Task {
//                do {
//                    let location = try await GeoCoderUseCase().geocode(with: city)
//                } catch {
//
//                }
//            }
//        }
//    }
//
//
//    func geocode(_ cities: [String]) async -> AsyncStream<Int> {
//        return AsyncStream { continuation in
//            for city in cities {
//                do {
//                    let location = try await GeoCoderUseCase().geocode(with: city)
//                    continuation.yield(location)
//                } catch {
//                    continuation.finish(throwing: error)
//                }
//            }
//            continuation.finish()
//        }
//    }
    
    func geocode(with city: String) async throws -> CLLocationCoordinate2D {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.geocodeAddressString(city)
        guard let placemark = placemarks.first,
              let location = placemark.location else {
            throw NSError(domain: "com.example.geocoding",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to geocode city"])
            
        }
        
        return location.coordinate
    }
}
