//
//  GeoCoderUseCase.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import Foundation

// Domain layer
protocol GeocodeUseCase {
    associatedtype Input
    associatedtype Output
    func execute(with input: Input) async throws -> Output
}
