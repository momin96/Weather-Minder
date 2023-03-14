//
//  DataParser.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation

protocol Parseable {
    associatedtype Input
    associatedtype Output
    func parse(with input: Input) async throws -> Output
}

struct DataParser<Input: Any, Output: Decodable>: Parseable {
    func parse(with input: (Data, URLResponse)) async throws -> Output {
        guard let httpResponse = input.1 as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "app.web.nasirmomin.getweatherusecase",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to parse weather"])
        }
        
        let weatherResponse = try JSONDecoder().decode(Output.self, from: input.0)
        return weatherResponse
    }
}
