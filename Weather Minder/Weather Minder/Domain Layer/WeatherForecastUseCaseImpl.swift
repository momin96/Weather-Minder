//
//  WeatherForecastUseCaseImpl.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

// MARK: - WeatherForecastUseCaseImpl
// UseCase for Fetching Forecast Data based on Current location's coordinates, which confirms to `WeatherUseCase`
struct WeatherForecastUseCaseImpl: WeatherUseCase {
    
    typealias Input = CLLocationCoordinate2D
    typealias Output = WeatherForecastResponse
    
    let getWeatherForecastDataService: GetWeatherForecastDataServiceImpl
    
    func execute(with input: Input) async throws -> WeatherForecastResponse {
        let (data, response) = try await getWeatherForecastDataService.execute(with: input)
        
        typealias ParseInputType = (Data, URLResponse)
        typealias ParseOutputType = WeatherForecastResponse
        
        return try await DataParser<ParseInputType, ParseOutputType>().parse(with: (data, response))
    }
}
