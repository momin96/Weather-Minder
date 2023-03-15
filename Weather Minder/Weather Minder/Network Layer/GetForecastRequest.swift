//
//  GetForecastRequest.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation

struct GetForecastRequest: Request {
    typealias ReturnType = WeatherForecastResponse
    var method: HTTPMethod = .get
}
