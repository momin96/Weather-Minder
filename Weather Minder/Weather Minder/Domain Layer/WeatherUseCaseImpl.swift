//
//  WeatherUseCaseImpl.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation

// MARK: - WeatherUseCaseImpl
/// UseCase for Fetching Weather based on searched City, which confirms to `WeatherUseCase`
struct WeatherUseCaseImpl: WeatherUseCase {
    
    typealias Input = City
    typealias Output = WeatherResponse
    
    let getWeatherDataService: GetWeatherDataServiceImpl
    
    func execute(with input: City) async throws -> WeatherResponse {
        let (data, response) = try await getWeatherDataService.execute(with: input)
        
        typealias ParseInputType = (Data, URLResponse)
        typealias ParseOutputType = WeatherResponse
        
        return try await DataParser<ParseInputType, ParseOutputType>().parse(with: (data, response))
    }
}
