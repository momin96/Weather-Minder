//
//  WeatherListViewModel.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import SwiftUI
import CoreLocation

class WeatherListViewModel: ObservableObject {
    @Published var searchText = "Mumbai,New York,Berlin"
    @Published var disableSearchButton = false
    @Published var cities: [City] = []

    let geocodeUseCase: GeocodeUseCase
    let weatherUseCase: WeatherUseCase
    
    init() {
        geocodeUseCase = GeocodeUseCaseImpl(geocodeDataService: GeocodeDataServiceImpl())
        weatherUseCase = WeatherUseCaseImpl(getWeatherDataService: GetWeatherDataServiceImpl())
    }
    
    func shouldEnabledSearch(from text: String) {
        let cities = text.components(separatedBy: ",")
        if cities.count < 3 || cities.count > 7 {
            disableSearchButton = true
        } else {
            disableSearchButton = false
        }
    }
    
    func performSearch(with text: String) {
        cities = []
        let cities = text.components(separatedBy: ",")
        for city in cities {
            Task {
                do {
                    let coordinates = try await geocodeUseCase.execute(with: city)
                    await getWeather(for: city, and: coordinates)
                } catch {
                    print(error)
                }
            }
        }
    }

    func getWeather(for cityName: String, and coordinates: CLLocationCoordinate2D) async {
        let city = City(name: cityName, coordinates: coordinates)
        do {
            let weatherResponse = try await weatherUseCase.execute(with: city)
            city.weather = weatherResponse
            cities.append(city)
        } catch {
            print("Error \(error)")
        }
    }
}
