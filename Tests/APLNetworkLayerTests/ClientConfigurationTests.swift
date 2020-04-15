//
//  ClientConfigurationTests.swift
//  APLNetworkLayerTests
//
//  Created by apploft on 15.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import XCTest
import Foundation
@testable import APLNetworkLayer

class ClientConfigurationTests: XCTestCase {
    
    let baseUrlStr = "https://example-url.com/example"
    let relativeUrlStr = "/ExamplePage"
    var urlStr: String = ""
    
    let exampleHeaderKey = "Application-Id"
    var defaultHeader: HTTPHeaders = [:]
    
    let testTimeout: TimeInterval = 5.0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        urlStr = baseUrlStr + relativeUrlStr
        defaultHeader = [exampleHeaderKey: "XXXXX12345"]
    }
    
    func testIfParametersSetCorrectlyWhenCreatingConfigurationWithoutParameters() {
//        let config = HTTPFactory.createConfiguration()
//        XCTAssertNotNil(config, "Config is nil. Has not been created!")
//        
//        XCTAssertNil(config?.baseURL, "BaseURL should be nil. Has not been set.")
//        XCTAssertEqual(config?.requestTimeout, HTTPHelper.DefaultRequestTimeout, "Default request timeout has not been set. Something broke")
//        XCTAssertNotNil(config?.urlSessionConfiguration, "URL session configuration has not been created. Something went wrong.")
//        let acceptLanguageValue = config?.urlSessionConfiguration.httpAdditionalHeaders?[HTTPHelper.PreferredLanguagesKey] as! String
//        XCTAssertNotNil(acceptLanguageValue, "Accept language header has to be created by default if non has been set. Has not been created!")
//        XCTAssertEqual(acceptLanguageValue, HTTPHelper.acceptLanguageValue, "Accept language header has to be created by default if non has been set. Value is not equal. Something went wrong")
//        // check config values celluar etc
    }
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
