//
//  HomeViewModel.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 15/03/23.
//

import CoreLocation

class HomeViewModel: ObservableObject {
    
    var locationManager: LocationManager? {
        didSet {
            didSetLocationManager()
        }
    }
    
    @Published var dateGroups: [DateGroup] = []
    @Published var currentCityName: String = ""
    @Published var errorMessage: String?
    
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
    
    func pullToRefresh() {
        locationManager?.setUpdates()
    }
    
    func getCurrentCity(for coordinates: CLLocationCoordinate2D) {
        Task {
            do {
                let currentCity = try await reverseGeocodeUseCase.execute(with: coordinates)
                await MainActor.run {
                    currentCityName = currentCity
                }
            } catch {
                await validation(of: error)
                throw error
            }
        }
    }
        
    func getWeather(for coordinates: CLLocationCoordinate2D) {
        Task {
            do {
                let forecastResponse = try await weatherForecastUseCase.execute(with: coordinates)
                let groups = forecastComputation(forecastResponse)
                await MainActor.run {
                    dateGroups = groups
                }
            } catch {
                await validation(of: error)
                throw error
            }
        }
    }

    func forecastComputation(_ response: WeatherForecastResponse) -> [DateGroup] {
        let weatherByDate = prepareGroups(for: response.list)
        let dateGroups = sortWeatherList(weatherByDate)
        return dateGroups
    }
    
    func prepareGroups(for weatherList: [WeatherDetail]) -> [String: [WeatherDetail]] {
        Dictionary(grouping: weatherList) { weather in
            return DateFormatter.stringInFormat_MMMddYYYY(for: weather.dt)
        }
    }
    
    func sortWeatherList(_ weatherByDate: [String: [WeatherDetail]]) -> [DateGroup] {
        var groups: [DateGroup] = []
        for date in weatherByDate.keys.sorted() {
            if let weatherDetails = weatherByDate[date] {
                let group = DateGroup(header: date, items: weatherDetails)
                groups.append(group)
            }
        }
        
        return groups
    }
    
    func validation(of error: Error) async {
        await MainActor.run {
            if let err = error as? NSError, err.code == -1003 {
                errorMessage = err.localizedDescription
            }
        }
    }
}
