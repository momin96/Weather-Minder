//
//  DataService.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation

protocol DataService {
    associatedtype Input
    associatedtype Output
    
    func execute(with input: Input) async throws -> Output
}

extension DataService {
    var serviceFetchingError: NSError {
        NSError(domain: "app.web.nasirmomin.serviceFetchingError",
                     code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Unable to fetch data of \(Input.self)"])
    }
    
    func make(_ request: URLRequest?) async throws -> (Data, URLResponse) {
        if let request {
            return try await URLSession.shared.data(for: request)
        }
        
        throw serviceFetchingError
    }
}
