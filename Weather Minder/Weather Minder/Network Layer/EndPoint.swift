//
//  EndPoint.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 13/03/23.
//

import Foundation

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
