//
//  HomeView.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import CoreLocation
import SwiftUI

struct WeatherForecastList: View {
    
    let forecastList: [WeatherDetail]
    
    var body: some View {
        List(forecastList, id: \.id) { list in
            /*@START_MENU_TOKEN@*/Text(list.dt_txt)/*@END_MENU_TOKEN@*/
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            
            Form {
                ForEach(viewModel.dateGroups, id: \.id ) { dateGroup in
                    Section {
                        WeatherForecastList(forecastList: dateGroup.items)
                    } header: {
                        Text(dateGroup.header)
                    }
                }
            }
            
            .navigationTitle("5 days forcast for " + viewModel.currentCityName)
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear {
            viewModel.locationManager = locationManager
        }
    }
}

class HomeViewModel: ObservableObject {
    
    var locationManager: LocationManager? {
        didSet {
            didSetLocationManager()
        }
    }
    
    @Published var dateGroups: [DateGroup] = []
    @Published var currentCityName: String = ""
    
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
                await MainActor.run {
                    currentCityName = currentCity
                }
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
                let groups = forecastComputation(forecastResponse)
                await MainActor.run {
                    dateGroups = groups
                }
            } catch {
                print(error)
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
            let date = Date(timeIntervalSince1970: TimeInterval(weather.dt))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM, dd yyyy"
            return dateFormatter.string(from: date)
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
}
