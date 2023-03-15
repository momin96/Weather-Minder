//
//  City.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation
import CoreLocation

class City: Codable, Identifiable {
    var id = UUID()
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
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case coordinates
        case weather
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        coordinates = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinates)
        weather = try container.decode(WeatherResponse.self, forKey: .weather)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(weather, forKey: .weather)
    }
}

extension CLLocationCoordinate2D: Codable {
    
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
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

struct Weather:Identifiable, Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    var weatherDescription: String {
        "It seems \(description)"
    }
}

struct Main: Codable {
    let tempMin: Double
    let tempMax: Double

    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    var minimumaAndMaximumTempreture: String {
        "Today min & max temprature would be \(String(format: "%.2f", tempMin)) \(String(format: "%.2f", tempMax)) respectivly."
    }
}

struct Wind: Codable {
    let speed: Double
    
    var windSpeedString: String {
        "Wind speed is about \(String(format: "%.2f", speed))"
    }
}
