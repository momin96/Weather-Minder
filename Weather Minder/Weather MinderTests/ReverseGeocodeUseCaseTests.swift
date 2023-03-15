//
//  ReverseGeocodeUseCaseTests.swift
//  Weather MinderTests
//
//  Created by Nasir Ahmed Momin on 14/03/23.
//

import XCTest
import CoreLocation
@testable import Weather_Minder



//final class ReverseGeocodeUseCaseTests: XCTestCase {
//    
//    struct MockReverseGeocodeDataService: Geocodable {
//        typealias Input = CLLocationCoordinate2D
//        typealias Output = String
//        
//        var executeCalled: ((CLLocationCoordinate2D) async throws -> String)?
//        
//        func execute(with input: CLLocationCoordinate2D) async throws -> String {
//            try await executeCalled!(input)
//        }
//    }
//    
//    var sut: ReverseGeocodeDataServiceImpl!
//    
//    override func setUp() async throws {
//        try await super.setUp()
//        
//        sut = ReverseGeocodeDataServiceImpl()
//    }
//    
//    override func tearDown() async throws {
//        try await super.tearDown()
//    }
//    
//    func testExecuteWithValidInputReturnsExpectedResult() async throws {
//        
//        let expectedOutput = "123 Main St, San Francisco, CA, USA"
//        
//        var mockReverseGeocodeDataService = MockReverseGeocodeDataService()
//
//        mockReverseGeocodeDataService.executeCalled = { input in
//            XCTAssertEqual(input.latitude, 37.785834)
//            XCTAssertEqual(input.longitude, -122.406417)
//            return expectedOutput
//        }
//        
//        let useCase = ReverseGeocodeUseCaseImpl(reverseGeocodeDataService: mockReverseGeocodeDataService)
//
//        
//        let input = CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417)
//                let output = try await useCase.execute(with: input)
//                
//                XCTAssertEqual(output, expectedOutput)
//        
//        // Arrange
////        let input = CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186)
////        let expectedOutput = "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA"
////        mockDataService.expectedOutput = expectedOutput
////
////        // Act
////        let output = try await useCase.execute(with: input)
////
////        // Assert
////        XCTAssertEqual(output, expectedOutput)
////        XCTAssertEqual(mockDataService.executedInput, input)
//    }
//}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.longitude == rhs.longitude &&
        lhs.latitude == rhs.latitude
    }
}
