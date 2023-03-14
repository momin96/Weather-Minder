//
//  GetWeatherForCityRequest.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation

struct GetWeatherForCityRequest: Request {
    typealias ReturnType = WeatherResponse
    var method: HTTPMethod = .get
}
