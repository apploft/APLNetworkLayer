//
//  HTTPRequestConcrete.swift
//  APLNetworkLayer
//
//  Created by apploft on 18.07.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

/// Represents an HTTP request and implements the HTTPRequestProtocol. It provides a property to create an URLRequest. 
public class HTTPRequestConcrete: HTTPRequest {
    
    public var url: URL
    public var method: HttpRequestMethod
    public var queryParameters: HttpQueryParameters?
    public var headers: HTTPHeaders?
    public var body: Data?
    public var cachePolicy: URLRequest.CachePolicy
    public var timeoutInterval: TimeInterval
    
    public var urlRequest: URLRequest {
        return buildRequest()
    }
    
    /**
     Initializer of the HTTP request.
     
     - Parameter url: Absolute URL of the request.
     - Parameter method: HTTP method of the request. Can be GET, POST, PUT or DELETE.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: The body of a POST or PUT request. Default value is nil. 
     - Parameter cachePolicy: Cache policy of the request.
     - Parameter timeoutInterval: The timeout interval for this particular request.
    */
    init(url: URL, method: HttpRequestMethod, queryParameters: HttpQueryParameters? = nil,
         headers: HTTPHeaders? = nil, body: Data? = nil,
         cachePolicy: URLRequest.CachePolicy,
         timeoutInterval: TimeInterval) {
        self.url = url
        self.method = method
        self.queryParameters = queryParameters
        self.headers = headers
        self.body = body
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
    }
    
    /**
     Builds the URL request of the HTTP request.
     - Returns: An URL request with the values set in the HTTPRequest.
    */
    private func buildRequest() -> URLRequest {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        urlComponents?.queryItems = queryParameters?.map { (key, value) in
            return URLQueryItem(name: key, value: value)
        }
        
        var request = URLRequest(url: (urlComponents?.url)!, cachePolicy: self.cachePolicy, timeoutInterval: self.timeoutInterval)
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers as? [String:String]
        
        switch method {
        case .POST, .PUT:
            request.httpBody = body
        default:
            break
        }
        return request
    }
}
