//
//  WeatherForecastResponse.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation

struct WeatherForecastResponse: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherDetail]
//    let city: City
}

struct WeatherDetail: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
//    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
//    let rain: Rain?
//    let sys: Sys
    let dt_txt: String
}

//struct Main: Codable {
//    let temp: Double
//    let feels_like: Double
//    let temp_min: Double
//    let temp_max: Double
//    let pressure: Int
//    let sea_level: Int
//    let grnd_level: Int
//    let humidity: Int
//    let temp_kf: Double
//}

//struct Weather: Codable {
//    let id: Int
//    let main: String
//    let description: String
//    let icon: String
//}

//struct Clouds: Codable {
//    let all: Int
//}

//struct Wind: Codable {
//    let speed: Double
//    let deg: Int
//    let gust: Double
//}

//struct Rain: Codable {
//    let threeHour: Double
//
//    enum CodingKeys: String, CodingKey {
//        case threeHour = "3h"
//    }
//}

//struct Sys: Codable {
//    let pod: String
//}

//struct City: Codable {
//    let id: Int
//    let name: String
//    let coord: Coord
//    let country: String
//    let population: Int
//    let timezone: Int
//    let sunrise: Int
//    let sunset: Int
//}

//struct Coord: Codable {
//    let lat: Double
//    let lon: Double
//}
