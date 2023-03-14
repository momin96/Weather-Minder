//
//  EndPoint.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import Foundation
import CoreLocation

enum Constants {
    static var APIKey = "3a86705615ad0202891a89647da3b629"
}

enum EndPoint1 {
    case getWeatherForCityWith(coordinate: CLLocationCoordinate2D)
}

// https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
extension EndPoint1 {
    
    var apiURL: URL? {
        let baseURL = "https://api.openweathermap.org/data/2.5/"
        switch self {
        case .getWeatherForCityWith(let coordinate):
            let path = "weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(Constants.APIKey)"
            return URL(string: baseURL + path) 
        }
    }
}

public struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "https://api.openweathermap.org/data/2.5"
        components.path = "/" + path

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }
}
