//
//  HTTPClientConfiguration.swift
//  APLNetworkLayer
//
//  Created by apploft on 17.09.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

/// An HTTP client configuration captures common parameter necessary to configure an HTTP client and serves a factory for HTTP request objects. This class makes it easy to configure a HTTP client against different backends and specify a common set of HTTP header parameter to be added to each and every request.
public protocol HTTPClientConfiguration: class {
    
    /// Contains settings for the URL session like cellular data options or the default headers for the requests.
    var urlSessionConfiguration: URLSessionConfiguration { get }
    
    /// The base URL for this configuration. Optional but creating requests with relative URLs cannot be used without a base URL.
    var baseURL: URL? { get }
    
    /// The timeout interval that will be set in the requests. This is not the timeout interval set in the session configuration, which starts counting when the request is put in the queue and not actually executed. This variable sets the actual timeout of the request when it is executed.
    var requestTimeout: TimeInterval { get }
        
    /**
     HTTPClientConfiguration serves as factory to create HTTP requests. Creates a request of a relative URL. Can only be used if base URL was provided.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter method: The HTTP method of the request. Can be GET, POST, PUT or DELETE. Mandatory parameter.
     - Parameter queryParameter: A dictionary of type [String: String] that contains the query parameters.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers.
     - Parameter body: The body of a POST or PUT request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request.
     
     - Returns: An HTTP request with the provided parameters or default values. Is optional because creating a HTTP request is not possible if base URL is not specified. 
     */
    func request(relativeUrl: String, method: HttpRequestMethod, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest?
    
    /**
     HTTPClientConfiguration serves as factory to create HTTP requests. Creates a request of an absolute URL.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter method: The HTTP method of the request. Can be GET, POST, PUT or DELETE.
     - Parameter queryParameter: A dictionary of type [String: String] that contains the query parameters.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers.
     - Parameter body: The body of a POST or PUT request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request.
     
     - Returns: An HTTP request with the provided parameters or default values.
     */
    func request(absoluteUrl: URL, method: HttpRequestMethod, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest
    
}

extension HTTPClientConfiguration {
    
    public func request(relativeUrl: String,
                        method: HttpRequestMethod,
                        queryParameters: HttpQueryParameters? = nil,
                        headers: HTTPHeaders? = nil,
                        body: Data? = nil,
                        cachePolicy: URLRequest.CachePolicy? = nil,
                        timeoutInterval: TimeInterval? = nil) -> HTTPRequest? {
        return request(relativeUrl: relativeUrl, method: method, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    public func request(absoluteUrl: URL,
                       method: HttpRequestMethod,
                       queryParameters: HttpQueryParameters? = nil,
                       headers: HTTPHeaders? = nil,
                       body: Data? = nil,
                       cachePolicy: URLRequest.CachePolicy? = nil,
                       timeoutInterval: TimeInterval? = nil) -> HTTPRequest {
        return request(absoluteUrl: absoluteUrl, method: method, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
}
