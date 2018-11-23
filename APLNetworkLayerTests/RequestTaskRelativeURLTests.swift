//
//  RequestTaskRelativeURLTests.swift
//  APLNetworkLayerTests
//
//  Created by Christine Pühringer on 05.10.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import XCTest
import Foundation
@testable import APLNetworkLayer

class RequestTaskRelativeURLTests: XCTestCase {
    
    let baseUrlStr = "https://api.github.com/repos/apploft/APLNetworkLayer"
    let relativeUrlStrReadme = "/readme"
    
    private var httpClient: HTTPClient!
    
    override func setUp() {
        guard let baseUrl = URL(string: baseUrlStr) else {
            XCTFail("URL could not be created.")
            return
        }
        guard let clientConfiguration = HTTPFactory.createConfiguration(baseURL: baseUrl) else { return }
        httpClient = HTTPFactory.createClient(configuration: clientConfiguration)
    }
    
    func testGETRequest() {
        guard httpClient != nil else {
            XCTFail("Client could not be created. Something broke! Requests cannot be tested.")
            return
        }
        guard let request = httpClient.GETRequest(relativeUrl: relativeUrlStrReadme) else {
            XCTFail("Request could not be created. Something is broken.")
            return
        }
        let task = httpClient.createHTTPTask(urlRequest: request.urlRequest) { (result: APLNetworkLayer.HTTPResult<HTTPResponse>) in
            switch result {
            case .success(let httpResponse):
                switch httpResponse.state {
                case .serverError:
                    XCTFail("Request failed. Server error. Maybe you didn't mess that up.")
                case .clientError:
                    XCTFail("Request failed. Either something broke or you messed up the request! ")
                default:
                    print("Request is pending, redirecting ")
                }
                print("success! Some response arrived")
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
        }
        task.resume();
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
}
