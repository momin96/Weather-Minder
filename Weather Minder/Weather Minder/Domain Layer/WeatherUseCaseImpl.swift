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
        
        do {
            let weatherResponse = try await DataParser<ParseInputType, ParseOutputType>().parse(with: (data, response))
            let city = input
            city.weather = weatherResponse
            try Storage().store(value: city, for: input.name)
            return weatherResponse
        } catch {
            throw error
        }
    }
}

protocol Storagable {
    func store<T: Encodable>(value: T, for key: String) throws
    func retrive<T: Decodable>(for key: String) -> T?
}

struct Storage: Storagable {
    
    private let dataHolder = UserDefaults.standard
    
    func store<T: Encodable>(value: T, for key: String) throws {
        let encoder = JSONEncoder()
        guard let encodedData = try? encoder.encode(value) else {
            throw NSError(domain: "app.web.nasirmomin.storageError",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to store given data in storage"])
        }
        dataHolder.set(encodedData, forKey: key)
    }
    
    func retrive<T: Decodable>(for key: String) -> T? {
        guard let encodedData = dataHolder.object(forKey: key) as? Data,
              let response = try? JSONDecoder().decode(T.self, from: encodedData) else {
            return nil
        }
        return response
    }
}
