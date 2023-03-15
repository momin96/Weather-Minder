//
//  GetWeatherForecastDataServiceImpl.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import CoreLocation

struct GetWeatherForecastDataServiceImpl: DataService {
    typealias Input = CLLocationCoordinate2D
    typealias Output = (Data, URLResponse)

    func execute(with input: CLLocationCoordinate2D) async throws -> (Data, URLResponse) {
        
        let endPoint = Endpoint.getForecast(for: input)
        let urlRequest = GetForecastRequest().asURLRequest(endpoint: endPoint)
        
        return try await make(urlRequest)
    }
}
