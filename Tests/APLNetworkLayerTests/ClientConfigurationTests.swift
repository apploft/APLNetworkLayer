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
    
    func testIfParametersSetCorrectlyWhenCreatingConfigurationWith_BaseURL_URLSessionConfig_RequestTimeoutSet() {
        let baseUrl = URL(string: baseUrlStr)
        let urlSessionConfiguration = URLSessionConfiguration.default
        let requestTimeout: TimeInterval = 13
        let config = HTTPFactory.createConfiguration(baseURL: baseUrl, urlSessionConfiguration: urlSessionConfiguration, requestTimeout: requestTimeout)
        XCTAssertNotNil(config, "Config is nil. Has not been created!")
        
        XCTAssertNotNil(config?.baseURL, "BaseURL should have been set!")
        XCTAssertEqual(config?.baseURL, baseUrl, "Base URL is not equal to the one that has been set.")
        XCTAssertEqual(config?.requestTimeout, requestTimeout, "Parameter request timeout has not been set. Something broke")
        XCTAssertEqual(config?.urlSessionConfiguration, urlSessionConfiguration, "URL session configuration has not been set. Something went wrong.")
        
        let acceptLanguageValue = config?.urlSessionConfiguration.httpAdditionalHeaders?[HTTPHelper.PreferredLanguagesKey] as! String
        XCTAssertNotNil(acceptLanguageValue, "Accept language header has to be created by default if non has been set. Has not been created!")
        XCTAssertEqual(acceptLanguageValue, HTTPHelper.acceptLanguageValue, "Accept language header has to be created by default if non has been set. Value is not equal. Something went wrong")
    }
    
    func testIfParametersSetCorrectlyWhenCreatingConfigurationWith_BaseURL_DefaultHeader_RequestTimeout_AllowsCellularAccess_WaitsForConnectivity_Set() {
        let baseUrl = URL(string: baseUrlStr)
        let requestTimeout: TimeInterval = 13
        let config = HTTPFactory.createConfiguration(baseURL: baseUrl, defaultHeader: defaultHeader, requestTimeout: requestTimeout, allowsCellularAccess: false, waitsForConnectivity: false)
        XCTAssertNotNil(config, "Config is nil. Has not been created!")
                
        XCTAssertNotNil(config?.baseURL, "BaseURL should have been set!")
        XCTAssertEqual(config?.requestTimeout, requestTimeout, "Parameter request timeout has not been set. Something broke")
        XCTAssertNotNil(config?.urlSessionConfiguration, "URL session configuration has not been created. Something went wrong.")
        
        XCTAssertEqual(config?.urlSessionConfiguration.httpAdditionalHeaders?.count, defaultHeader.count + 1, "Not enough headers have been set. Something went wrong")
        
        let acceptLanguageValue = config?.urlSessionConfiguration.httpAdditionalHeaders?[HTTPHelper.PreferredLanguagesKey] as! String
        XCTAssertNotNil(acceptLanguageValue, "Accept language header has to be created by default if non has been set. Has not been created!")
        XCTAssertEqual(acceptLanguageValue, HTTPHelper.acceptLanguageValue, "Accept language header has to be created by default if non has been set. Value is not equal. Something went wrong")
        
        let headerValue = config?.urlSessionConfiguration.httpAdditionalHeaders?[exampleHeaderKey] as! String
        XCTAssertNotNil(headerValue, "Example default header has not been set. Has not been created!")
        XCTAssertEqual(headerValue, defaultHeader[exampleHeaderKey] as! String, "Example default header has not been set. Value is not equal. Something went wrong")
    }
    
    /// Tests if the request is generated correctly with the minimum amount of parameters set and if the default values are set.
    func testRequestCreatingWith_RelURL_GET() {
        let baseUrl = URL(string: baseUrlStr)
        let clientConfiguration = HTTPFactory.createConfiguration(baseURL: baseUrl, defaultHeader: defaultHeader)
        
        guard let request = clientConfiguration?.request(relativeUrl: relativeUrlStr, method: .GET) else {
            XCTFail("Request is nil. Could not be created.")
            return
        }
        
        // check if url is set correctly
        XCTAssertEqual(request.url.absoluteString, urlStr, "url not set in HTTPRequest")
        // check if method is set correctly
        XCTAssertEqual(request.method, HttpRequestMethod.GET, "method not set in HTTPRequest")
        
        // check if default values have been set
        XCTAssertNil(request.headers, "Something has been set in headers. Should not be there.")
        XCTAssertNil(request.queryParameters, "Something has been set in query parameters. Should not be there.")
        XCTAssertNil(request.body, "A body has been set. There should not be one, it's a GET request.")
        XCTAssertEqual(request.cachePolicy, .useProtocolCachePolicy, "Something differnet was set as default cache policy than defined.")
        XCTAssertEqual(request.timeoutInterval, HTTPHelper.DefaultRequestTimeout, "Something different was set as default timeout than defined.")
    }
    
    /// Tests if the request is generated correctly and all parameters are set.
    func testRequestCreatingWith_RelURL_GET_Header_CachePolicy_RequestTimeout() {
        let baseUrl = URL(string: baseUrlStr)
        let clientConfiguration = HTTPFactory.createConfiguration(baseURL: baseUrl, defaultHeader: defaultHeader)
        
        guard let request = clientConfiguration?.request(relativeUrl: relativeUrlStr, method: .GET, queryParameters: nil, headers: defaultHeader, body: nil, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: testTimeout) else {
            XCTFail("Request is nil. Could not be created.")
            return
        }
        
        // check if url is set correctly
        XCTAssertEqual(request.url.absoluteString, urlStr, "url not set in HTTPRequest")
        // check if method is set correctly
        XCTAssertEqual(request.method, HttpRequestMethod.GET, "method not set in HTTPRequest")
        
        // check if default values have been set
        XCTAssertNotNil(request.headers, "headers have not been set, is nil.")
         // TODO check if values in header are correct
       // XCTAssertEqual(request.headers!, defaultHeader, "stuff")
        // TODO set query parameter and test it, missing in call at the moment (set nil)
        XCTAssertNil(request.queryParameters, "Something has been set in query parameters. Should not be there.")
        XCTAssertNil(request.body, "A body has been set. There should not be one, it's a GET request.")
        XCTAssertEqual(request.cachePolicy, URLRequest.CachePolicy.reloadIgnoringLocalCacheData, "Value is something different than what was set")
        XCTAssertEqual(request.timeoutInterval, testTimeout, "Something different was set as default timeout than defined.")
    
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
