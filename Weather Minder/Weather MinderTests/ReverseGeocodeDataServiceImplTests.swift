//
//  ReverseGeocodeDataServiceImplTests.swift
//  Weather MinderTests
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import XCTest
import CoreLocation

@testable import Weather_Minder

class ReverseGeocodeDataServiceImplTests: XCTestCase {
    
    var sut: ReverseGeocodeDataServiceImpl!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = ReverseGeocodeDataServiceImpl()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
    }
    
    func testExecuteWithValidCoordinate() async throws {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let expectedCityName = "10 S Van Ness Ave"
        
        // When
        let result = try await sut.execute(with: coordinate)
        
        // Then
        XCTAssertEqual(result, expectedCityName)
    }
    
    func testExecuteWithInvalidCoordinate() async throws {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: -1000, longitude: 2000)
        
        // When
        do {
            let _ = try await sut.execute(with: coordinate)
            XCTFail("The test should throw an error.")
        } catch {
            // Then
            XCTAssertTrue(type(of: error) is NSError.Type)
        }
    }
}

