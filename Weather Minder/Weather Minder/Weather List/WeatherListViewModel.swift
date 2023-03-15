//
//  WeatherListViewModel.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import SwiftUI
import CoreLocation

class WeatherListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var disableSearchButton = false
    @Published var alertMessage: String?
    @Published var cities: [City] = [] {
        didSet {
            if !cities.isEmpty {
                alertMessage = nil
            }
        }
    }

    let geocodeUseCase: GeocodeUseCaseImpl
    let weatherUseCase: WeatherUseCaseImpl
    
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
        Task {
            for city in cities {
                do {
                    let coordinates = try await geocodeUseCase.execute(with: city)
                    await getWeather(for: city, and: coordinates)
                } catch {
                    await prepareCachedData(for: city)
                    validation(for: error, name: city)
                    throw error
                }
            }
        }
    }
    
    func validation(for error: Error, name: String)   {
        if cities.isEmpty {
            Task {
                await MainActor.run {
                    alertMessage = "Unable to find city with name \(name), Please search again!"
                }
            }
        }
    }

    func getWeather(for cityName: String, and coordinates: CLLocationCoordinate2D) async {
        do {
            let city = City(name: cityName, coordinates: coordinates)
            let weatherResponse = try await weatherUseCase.execute(with: city)
            city.weather = weatherResponse
            await MainActor.run {
                cities.append(city)
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    func prepareCachedData(for cityName: String) async {
        guard let wrappedData: City? = Storage().retrive(for: cityName),
            let cachedData = wrappedData else {
            return
        }
        
        await MainActor.run {
            cities.append(cachedData)
        }
    }
}
