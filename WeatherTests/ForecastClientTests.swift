//
//  ForecastClientTests.swift
//  Weather
//
//  Created by Adnan Aftab on 3/9/16.
//  Copyright © 2016 CX. All rights reserved.
//

import XCTest
@testable import Weather
class ForecastClientTests: XCTestCase {
    
    var forecastClient = ForecastClient()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConstructURLWithParamsMethod(){
        let params = ["name":"adnan"]
        var url = forecastClient.constructURLWithParams(params, forecast: true)
        XCTAssertNotNil(url, "URL should not be nil")
        let result = url!.absoluteString.containsString("name=adnan")
        XCTAssertTrue(result, "not containing provided params")
        let hasForecastEndPoint = url!.absoluteString.containsString("/forecast")
        XCTAssertTrue(hasForecastEndPoint, "Should have forecast end point")
        var hasWeatherEndPoint = url!.absoluteString.containsString("/weather")
        XCTAssertFalse(hasWeatherEndPoint, "Should not have weather endpoint")
        
        url = forecastClient.constructURLWithParams(params, forecast: false)
        hasWeatherEndPoint = url!.absoluteString.containsString("/weather")
        XCTAssertTrue(hasWeatherEndPoint, "Should have weather end point")
        
    }

}
