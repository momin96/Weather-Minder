//
//  HomeView.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import CoreLocation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    @State var viewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            WeatherListView()
            locationManager.currentLocation.map { location in
                HStack {
                    Text("\(location.coordinate.latitude)")
                    Text("  \(location.coordinate.longitude)")

                }
            }
        }.onAppear {
            viewModel.locationManager = locationManager
        }
    }
}

class HomeViewModel {
    
    var locationManager: LocationManager? {
        didSet {
            didSetLocationManager()
        }
    }
    
    let reverseGeocodeUseCase: ReverseGeocodeUseCaseImpl
    let weatherForecastUseCase: WeatherForecastUseCaseImpl
    
    init() {
        reverseGeocodeUseCase = ReverseGeocodeUseCaseImpl(reverseGeocodeDataService: ReverseGeocodeDataServiceImpl())
        weatherForecastUseCase = WeatherForecastUseCaseImpl(getWeatherForecastDataService: GetWeatherForecastDataServiceImpl())
    }
    
    func didSetLocationManager() {
        guard let coordinates = locationManager?.currentLocation?.coordinate else {
            return
        }
        getCurrentCity(for: coordinates)
        getWeather(for: coordinates)
    }
    
    func getCurrentCity(for coordinates: CLLocationCoordinate2D) {
        Task {
            do {
                let currentCity = try await reverseGeocodeUseCase.execute(with: coordinates)
                print("currentCity \(currentCity)")
            } catch {
                print(error)
            }
        }
    }
    
    // api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
    
    func getWeather(for coordinates: CLLocationCoordinate2D) {
        Task {
            do {
                let forecastResponse = try await weatherForecastUseCase.execute(with: coordinates)
                print(forecastResponse)
            } catch {
                print(error)
            }
        }
    }
}


