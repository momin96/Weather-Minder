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

// MARK: - WeatherUseCaseImpl
/// UseCase for Fetching Weather based on searched City, which confirms to `WeatherUseCase`
struct WeatherUseCaseImpl: WeatherUseCase {
    
    typealias Input = City
    typealias Output = WeatherResponse
    
    let getWeatherDataService: GetWeatherDataService
    
    func execute(with city: City) async throws -> WeatherResponse {
        let (data, response) = try await getWeatherDataService.getWeather(for: city)
        
        typealias ParseInputType = (Data, URLResponse)
        typealias ParseOutputType = WeatherResponse
        
        return try await DataParser<ParseInputType, ParseOutputType>().parse(with: (data, response))
    }
}

// MARK: - WeatherForecastUseCaseImpl
// UseCase for Fetching Forecast Data based on Current location's coordinates, which confirms to `WeatherUseCase`
struct WeatherForecastUseCaseImpl: WeatherUseCase {
    
    typealias Input = CLLocationCoordinate2D
    typealias Output = WeatherForecastResponse
    
    let getWeatherForecastDataService: GetWeatherForecastDataService
    
    func execute(with input: Input) async throws -> WeatherForecastResponse {
        let (data, response) = try await getWeatherForecastDataService.getForecast(for: input)
        
        typealias ParseInputType = (Data, URLResponse)
        typealias ParseOutputType = WeatherForecastResponse
        
        return try await DataParser<ParseInputType, ParseOutputType>().parse(with: (data, response))
    }
}
