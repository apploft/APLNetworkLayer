//
//  HTTPResponse.swift
//  APLNetworkLayer
//
//  Created by apploft on 22.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

/// States to map the status codes of the http url responses. The undefined code is only for internal error purposes using the network layer or unknown status codes.
public enum ResponseState {
    case pending
    case success
    case redirect
    case clientError
    case serverError
    case undefined
}

/// A protocol for a HTTP response. Holds the URLResponse and the Data object.
public protocol HTTPResponse: class {
    
    /// The response as an URLResponse object.
    var urlResponse: URLResponse { get }
    /// The Data object if there is data attatched to the response. 
    var data: Data? { get }
    
    /// The status code of the url response as state of the ResponseState enum. Returns .undefined if the status code is not recognized.
    var state: ResponseState { get }
    
}
