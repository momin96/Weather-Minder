//
//  EndPoint.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import Foundation
import CoreLocation

enum AppConstants {
    static let APIKey: String                 = "3a86705615ad0202891a89647da3b629"
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
            let path = "weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(AppConstants.APIKey)"
            return URL(string: baseURL + path) 
        }
    }
}

public struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var apiURL: URL? {
        let baseURL = "https://api.openweathermap.org/data/2.5/"
        return URL(string: baseURL + path)
    }
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

extension Endpoint {
    static func getForecast(for coordinates: CLLocationCoordinate2D) -> Self {
        Endpoint(path: "forecast?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(AppConstants.APIKey)")
    }
    
    static func getWeatherForCity(with coordinates: CLLocationCoordinate2D) -> Self {
        Endpoint(path: "weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(AppConstants.APIKey)")
    }
}

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

public protocol Request {
    var method: HTTPMethod { get }
    var body: [String: Any]? { get }
    var bodyArray: [Any]? { get }
    var headers: [String: String]? { get }
    associatedtype ReturnType: Codable
}

// MARK: - Default parameters
extension Request {
    var method: HTTPMethod { .get }
    var body: [String: Any]? { nil }
    var bodyArray: [Any]? { nil }
    var headers: [String: String]? { nil }
}

private enum Constants {
    static let tokenHeaderField: String       = "Token"
    static let contentTypeHeaderField: String = "Content-Type"
    static let acceptHeaderField: String      = "Accept"
    static let jsonHeaderValue: String        = "application/json"
}

extension Request {
    func asURLRequest(endpoint: Endpoint) -> URLRequest? {
        guard let url = endpoint.apiURL else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(Constants.jsonHeaderValue, forHTTPHeaderField: Constants.contentTypeHeaderField)
        request.addValue(Constants.jsonHeaderValue, forHTTPHeaderField: Constants.acceptHeaderField)

        if body == nil {
            request.httpBody = bodyArray?.jsonData()
        } else {
            request.httpBody = body?.jsonData()
        }

        request.allHTTPHeaderFields = headers
        return request
    }
}

extension Encodable {
    /// This method converts a Encodable Type to a Dictionary.
    ///
    /// - Returns: Optional Dictionary
    var asDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }

        return dictionary
    }

    /// This method converts a Encodable Type to an Array.
    ///
    /// - Returns: Optional Array
    var asArray: [Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] else {
            return nil
        }

        return array
    }
}

public extension Dictionary {
    /// Serialises an HTTP dictionary to a JSON Data Object
    ///
    /// - Returns: Encoded JSON
    func jsonData() -> Data {
        (try? JSONSerialization.data(withJSONObject: self, options: [])) ?? Data()
    }
}

public extension Array {
    /// Serialises an HTTP Array to a JSON Data Object
    ///
    /// - Returns: Encoded JSON
    func jsonData() -> Data {
        (try? JSONSerialization.data(withJSONObject: self, options: [])) ?? Data()
    }
}
