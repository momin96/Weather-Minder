//
//  Utils.swift
//  Weather Minder
//
//  Created by Nasir Ahmed Momin on 15/03/23.
//

import Foundation

typealias DateTimeFormatter = DateFormatter

extension DateTimeFormatter {
    static let formatter = DateTimeFormatter()
    
    static func stringInFormat_MMMddYYYY(for epoch: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(epoch))
        formatter.dateFormat = "MMM, dd yyyy"
        return formatter.string(from: date)
    }
    
    static func stringInFormat_hhmma(for epoch: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(epoch))
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}
