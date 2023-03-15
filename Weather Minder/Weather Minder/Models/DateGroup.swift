//
//  DateGroup.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 15/03/23.
//

import Foundation

struct DateGroup {
    let id = UUID()
    let header: String
    let items: [WeatherDetail]
}
