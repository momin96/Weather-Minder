//
//  HomeViewModelTests.swift
//  Weather MinderTests
//
//  Created by Nasir Ahmed Momin on 15/03/23.
//

import XCTest
@testable import Weather_Minder

class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    
    let weatherDetail1 = WeatherDetail(
        dt: 1647532800,
        main: Main(tempMin: 10.0, tempMax: 35.0),
        weather: [],
        wind: Wind(speed: 5.0),
        visibility: 10000,
        pop: 0.0,
        dt_txt: "Mar, 17 2022 00:00:00"
    )
    
    let weatherDetail2 = WeatherDetail(
        dt: 1647619200,
        main: Main(tempMin: 10.0, tempMax: 35.0),
        weather: [],
        wind: Wind(speed: 5.0),
        visibility: 10000,
        pop: 0.0,
        dt_txt: "Mar, 18 2022 00:00:00"
    )
    
    override func setUp() async throws {
        try await super.setUp()
        
        sut = HomeViewModel()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
        sut = nil
    }
    
    func testPrepareGroups_WithEmptyWeatherList_ReturnsEmptyDictionary() {

        let emptyWeatherList: [WeatherDetail] = []
        
        let result = sut.prepareGroups(for: emptyWeatherList)
        
        XCTAssertEqual(result.count, 0)
    }
    
    func testPrepareGroups_WithSingleWeatherDetail_ReturnsDictionaryWithOneEntry() {

        let weatherList = [weatherDetail1]
        
        let result = sut.prepareGroups(for: weatherList)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.keys.first, "Mar, 17 2022")
        XCTAssertEqual(result.values.first?.count, 1)
        XCTAssertEqual(result.values.first?.first?.dt, weatherDetail1.dt)
        XCTAssertEqual(result.values.first?.first?.main.tempMin, weatherDetail1.main.tempMin)
        XCTAssertEqual(result.values.first?.first?.main.tempMax, weatherDetail1.main.tempMax)
        XCTAssertEqual(result.values.first?.first?.wind.speed, weatherDetail1.wind.speed)
        XCTAssertEqual(result.values.first?.first?.visibility, weatherDetail1.visibility)
        XCTAssertEqual(result.values.first?.first?.pop, weatherDetail1.pop)
        XCTAssertEqual(result.values.first?.first?.dt_txt, weatherDetail1.dt_txt)
    }
    
    func testPrepareGroups_WithMultipleWeatherDetails_ReturnsDictionaryWithMultipleEntries() {

        let weatherList = [weatherDetail1, weatherDetail2]
        
        let result = sut.prepareGroups(for: weatherList)
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.keys.sorted(), ["Mar, 17 2022", "Mar, 18 2022"])
        XCTAssertEqual(result.values.first?.count, 1)
        XCTAssertEqual(result.values.first?.first!.dt, weatherDetail1.dt)
    }
}
