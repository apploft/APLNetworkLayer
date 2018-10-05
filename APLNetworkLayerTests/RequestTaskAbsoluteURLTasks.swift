//
//  RequestTaskAbsoluteURLTasks.swift
//  APLNetworkLayerTests
//
//  Created by Christine Pühringer on 05.10.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import XCTest
import Foundation
@testable import APLNetworkLayer

class RequestTaskAbsoluteURLTasks: XCTestCase {
    
    private var httpClient: HTTPClient!

    override func setUp() {
        guard let clientConfiguration = HTTPFactory.createConfiguration() else { return }
        httpClient = HTTPFactory.createClient(configuration: clientConfiguration)
    }
    
    func testGETRequest() {
        guard httpClient != nil else {
            XCTFail("Client could not be created. Something broke! Requests cannot be tested.")
            return
        }
        guard let url = URL(string: "https://api.github.com/repos/apploft/APLNetworkLayer/readme") else {
            XCTFail("URL could not be created.")
            return
        }
         let request = httpClient.GETRequest(absoluteUrl: url)
        let task = httpClient.createHTTPTask(urlRequest: request.urlRequest) { (result: APLNetworkLayer.Result<HTTPResponse>) in
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
