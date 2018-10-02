//
//  HTTPResponseConcrete.swift
//  APLNetworkLayer
//
//  Created by apploft on 22.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation
import os

/// Contains data and url response object, conforms to the the HTTPResponse protocol. Is a class because there would be problems with the variables of reference type being nil if it was a struct.
public class HTTPResponseConcrete: HTTPResponse {
    
    public var urlResponse: URLResponse
    
    public var data: Data?
    
    /**
     Initializer for the http response.
     - Parameter urlResponse: URL response oject that was received.
     */
    public init(urlResponse: URLResponse) {
        self.urlResponse = urlResponse
    }
    
    public var state: ResponseState {
        guard let httpURLResponse = urlResponse.httpUrlResponse else {
            os_log("Something went wrong: URLResponse is not a HTTPURLResponse!", log: customLog, type: .error)
            return .undefined
        }
        switch httpURLResponse.statusCode {
        case HTTPURLResponse.PendingStatusCodeRange:
            return .pending
        case HTTPURLResponse.SuccessStatusCodeRange:
            return .success
        case HTTPURLResponse.RedirectStatusCodeRange:
            return .redirect
        case HTTPURLResponse.ClientErrorStatusCodeRange:
            return .clientError
        case HTTPURLResponse.ServerErrorStatusCodeRange:
            return .serverError
        default:
            os_log("Unknown status code: %d", log: customLog, type: .error, httpURLResponse.statusCode)
            return .undefined
        }
    }
    
    //
    // MARK: - PRIVATE
    //
    
    /// Logging subsystem for custom logging
    private static let logSubsystem = "de.apploft.networkapp.HTTPResponseConcrete"
    private let customLog = OSLog(subsystem: logSubsystem, category: "Response")
}
