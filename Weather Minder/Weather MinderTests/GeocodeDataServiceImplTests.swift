//
//  GeocodeDataServiceImplTests.swift
//  Weather MinderTests
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import XCTest
import CoreLocation
@testable import Weather_Minder

final class GeocodeDataServiceImplTests: XCTestCase {
    
    var sut: GeocodeDataServiceImpl!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = GeocodeDataServiceImpl()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
    }
    
    func testExecuteWithValidAddress() async throws {
        // given
        let address = "1600 Amphitheatre Parkway, Mountain View, CA"
        
        // when
        let coordinate = try await sut.execute(with: address)
        
        // then
        XCTAssertNotNil(coordinate)
    }
    
    func testExecuteWithInvalidAddress() async throws {
        // given
        let address = "Invalid address"
        
        // when
        do {
            let coordinate = try await sut.execute(with: address)
            XCTFail("Expected an error, but received \(coordinate)")
        } catch let error {
            // then
            XCTAssertTrue(type(of: error) is NSError.Type)
        }
    }
}
