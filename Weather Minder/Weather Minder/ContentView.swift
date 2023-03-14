//
//  ContentView.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .searchable(text: $viewModel.searchText,
                        prompt: Text("Enter cities name by comma separated"))
            .onChange(of: viewModel.searchText) { newValue in
                viewModel.shouldEnabledSearch(from: newValue)
            }
            .onSubmit(of: .search) {
                viewModel.performSearch(with: viewModel.searchText)
            }
            .disableAutocorrection(viewModel.disableSearchButton)
        }
        .navigationTitle("Searchable List")
    }
}

class ContentViewModel: ObservableObject {
    @Published var searchText = "Mumbai, New York, Berlin"
    @Published var disableSearchButton = false
    
    func shouldEnabledSearch(from text: String) {
        let cities = text.components(separatedBy: ",")
        if cities.count < 3 || cities.count > 7 {
            disableSearchButton = true
        } else {
            disableSearchButton = false
        }
    }
    
    func performSearch(with text: String) {
        let cities = text.components(separatedBy: ",")
        for city in cities {
            Task {
                do {
                    let coordinates = try await GeoCoderUseCase().geocode(with: city)
                    getWeather(for: city, and: coordinates)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func getWeather(for city: String, and coordinates: CLLocationCoordinate2D) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


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
