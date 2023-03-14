//
//  WeatherUseCase.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation

protocol WeatherUseCase {
    func execute(with city: City) async throws -> WeatherResponse
}

struct WeatherUseCaseImpl: WeatherUseCase {
    let getWeatherDataService: GetWeatherDataService
    
    func execute(with city: City) async throws -> WeatherResponse {
        let (data, response) = try await getWeatherDataService.getWeather(for: city)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "app.web.nasirmomin.getweatherusecase",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to parse weather"])
        }
        
        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return weatherResponse
    }
}
