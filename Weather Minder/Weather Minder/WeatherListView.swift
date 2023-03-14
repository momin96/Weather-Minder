//
//  WeatherListView.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import SwiftUI
import CoreLocation

struct WeatherListView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    List {
                        ForEach(viewModel.cities, id: \.id) { city in
                            WeatherCard(city: city)
                        }
                    }
                }
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

struct WeatherCard: View {
    
    var city: City
    var body: some View {
        VStack(alignment: .leading) {
            Text("In \(city.name)")
            city.weather.map { response in
                VStack(alignment: .leading) {
                    Text(response.main.minimumaAndMaximumTempreture)
                    Text(response.wind.windSpeedString)
                    
                    WeatherDescriptionView(weather: response.weather)
                }
            }
        }
    }
}


struct WeatherDescriptionView: View {
    let weather: [Weather]
    var body: some View {
        Group {
            ForEach(weather) { weather in
                Text(weather.weatherDescription)
            }
        }
    }
}

class ContentViewModel: ObservableObject {
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

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
