//
//  City.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation
import CoreLocation

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
    let wind: Wind
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
    let tempMin: Double
    let tempMax: Double

    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Wind: Codable {
    let speed: Double
}
