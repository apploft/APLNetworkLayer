//
//  HTTPRequest.swift
//  APLNetworkLayer
//
//  Created by apploft on 13.07.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

/// Represents a dictionary format of [String: String] for the HTTP query parameters.
public typealias HttpQueryParameters = [String: String]

/// Represents a dictionary format of [AnyHashable: Any] for the HTTP headers.
public typealias HTTPHeaders = [AnyHashable: Any]

/// Enum with the HTTP methods as cases GET, POST, PUT and DELETE.
public enum HttpRequestMethod: String {
    case GET, PATCH, POST, PUT, DELETE
}

/// A protocol for a HTTP request. 
public protocol HTTPRequest: class {
    
    /// Absolute URL of the request.
    var url: URL { get }
    
    /// HTTP method of the request. Can be GET, POST, PUT or DELETE.
    var method: HttpRequestMethod { get }
    
    /// A dictionary of type [String: String] that contains the query parameters.
    var queryParameters: HttpQueryParameters? { get set }
    
    /// A dictionary of type [AnyHashable: Any] that contains the headers.
    var headers: HTTPHeaders? { get set }
    
    /// The body of a POST or PUT request.
    var body: Data? { get set }
    
    /// Cache policy of the request.
    var cachePolicy: URLRequest.CachePolicy { get set }
    
    /// The timeout interval for this particular request.
    var timeoutInterval: TimeInterval { get set }
    
    /// Creates an URLRequest of the HTTPRequest.
    var urlRequest: URLRequest { get }
}
