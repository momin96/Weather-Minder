//
//  GetWeatherDataServiceImpl.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

struct GetWeatherDataServiceImpl: DataService {
    
    typealias Input = City
    typealias Output = (Data, URLResponse)
    
    func execute(with input: City) async throws -> (Data, URLResponse) {
        let endPoint = Endpoint.getWeatherForCity(with: input.coordinates)
        let urlRequest = GetWeatherForCityRequest().asURLRequest(endpoint: endPoint)
        
        return try await make(urlRequest)
    }
}
