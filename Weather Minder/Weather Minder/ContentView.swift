//
//  ContentView.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import SwiftUI
import CoreLocation

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
    let getWeatherUseCase = GetWeatherUseCase()
    func getWeather(for cityName: String, and coordinates: CLLocationCoordinate2D) {
        let city = City(name: cityName, coordinates: coordinates)
        getWeatherUseCase.execute(with: city)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

import Combine
class GetWeatherUseCase {
    
    private var subscriptions = Set<AnyCancellable>()
    
    func execute(with city: City) {
        let endPoint = EndPoint1.getWeatherForCityWith(coordinate: city.coordinates)
        if let url = endPoint.apiURL {
            print("url \(url)")
            let pub = URLSession.shared.dataTaskPublisher(for: url)
            pub.sink { completion in
                print("completion \(completion)")
            } receiveValue: { (data: Data, response: URLResponse) in
                print("data \(data) response \(response)")
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                         let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                        print(weatherResponse)
                    } catch {
                        print("Error \(error)")
                    }
                }
            }
            .store(in: &subscriptions)
        }
    }
}


class City {
    var name: String
    var coordinates: CLLocationCoordinate2D
    var weather: WeatherResponse?
    
    init(
        name: String,
        coordinates: CLLocationCoordinate2D,
        weather: WeatherResponse? = nil
    ) {
        self.name = name
        self.coordinates = coordinates
        self.weather = weather
    }
}


struct WeatherResponse: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let base: String
    let main: Main
//    let visibility: Int
    let wind: Wind
//    let rain: Rain?
//    let clouds: Clouds
//    let dt: Int
//    let sys: Sys
//    let timezone: Int
//    let id: Int
//    let name: String
//    let cod: Int
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
//    let temp: Double
//    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
//    let pressure: Int
//    let humidity: Int
//    let seaLevel: Int
//    let grndLevel: Int

    enum CodingKeys: String, CodingKey {
//        case temp
//        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
//        case pressure
//        case humidity
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
    }
}

struct Wind: Codable {
    let speed: Double
//    let deg: Int
//    let gust: Double
}

struct Rain: Codable {
    let oneHour: Double

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
