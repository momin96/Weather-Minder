//
//  WeatherUseCase.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

protocol WeatherUseCase {
    associatedtype Input
    associatedtype Output
    func execute(with input: Input) async throws -> Output
}

struct WeatherUseCaseImpl: WeatherUseCase {
    
    typealias Input = City
    typealias Output = WeatherResponse
    
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

struct WeatherForecastUseCaseImpl: WeatherUseCase {
    
    typealias Input = CLLocationCoordinate2D
    typealias Output = WeatherForecastResponse
    
    let getWeatherForecastDataService: GetWeatherForecastDataService
    
    func execute(with input: Input) async throws -> WeatherForecastResponse {
        let (data, response) = try await getWeatherForecastDataService.getForecast(for: input)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "app.web.nasirmomin.getweatherusecase",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to parse weather"])
        }
        
        let forecastResponse = try JSONDecoder().decode(WeatherForecastResponse.self, from: data)
        return forecastResponse
    }
}
