//
//  GetWeatherDataService.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation

protocol GetWeatherDataService {
    func getWeather(for city: City) async throws -> (Data, URLResponse)
}

struct GetWeatherDataServiceImpl: GetWeatherDataService {
    func getWeather(for city: City) async throws -> (Data, URLResponse) {
        let endPoint = EndPoint1.getWeatherForCityWith(coordinate: city.coordinates)
        if let url = endPoint.apiURL {
            return try await URLSession.shared.data(from: url)
        }
        throw NSError(domain: "app.web.nasirmomin.getweatherusecase",
                      code: 1,
                      userInfo: [NSLocalizedDescriptionKey: "Unable to fetch city's weather"])
    }
}
