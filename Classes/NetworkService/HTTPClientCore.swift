//
//  HTTPClientCore.swift
//  APLNetworkLayer
//
//  Created by apploft on 18.09.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

public typealias HTTPClient = HTTPClientCore & ConvenienceRequestCreating & ConvenienceRequestExecuting

/// typealias for the network completion handler with a HTTPResponse or Error as parameters and returns Void
public typealias NetworkCompletionHandler = (HTTPResult<HTTPResponse>) -> Void

/**
 Result enum to handle the success and failure cases of the HTTP request.
 - case success(T) returns an object of type T that implements the Decodable protocol in success case.
 - case failure(Error) returns an object of type error containing the details of the error in case of failure.
 */
public enum HTTPResult<T> {
    /// Returns an object of type T in success case.
    case success(T)
    /// eturns an object of type error containing the details of the error in case of failure.
    case failure(Error)
}

/// HTTPClient provides a interface to communicate with the server. Create and send requests and handle tasks.
public protocol HTTPClientCore: class {
    
    /// An optional property to set the desired operation queue for running the completion handler operations.
    var completionHandlerOperationQueue: OperationQueue? { get set }
    
    /// Maximum number of retries per task that are executed.
    var maxRetries: Int { get set }
    
    /**
     Creates an HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration, and the HTTP method, which can be chosen of an enum. Calls the request method of the HTTPClientConfiguration to build the request. Can only be used if a base URL was provided in the configuration, will fail otherwise.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter method: The http method of the request. Can be GET, POST, PUT or DELETE from the enum HTTPMethods.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request. Only relevant for POST, PUT and eventually DELETE requests. Default is nil.
     - Parameter cachePolicy: Cache policy of the URL request. If not set, ProtocolCachePolicy will be set.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An object with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    func createRequest(relativeUrl: String, method: HttpRequestMethod, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest?
    
    /**
     Creates an HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration, and the HTTP method, which can be chosen of an enum. Calls the request method of the HTTPClientConfiguration to build the request.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter method: The http method of the request. Can be GET, POST, PUT or DELETE from the enum HTTPMethods.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request. Only relevant for POST, PUT and eventually DELETE requests. Default is nil.
     - Parameter cachePolicy: Cache policy of the URL request. If not set, ProtocolCachePolicy will be set.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An object with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    func createRequest(absoluteUrl: URL, method: HttpRequestMethod, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest
 
    /**
     Takes an URLRequest as a parameter and executes it. Creates and resumes a task with the URLSession in the process which is saved in a directory and returns the task conforming to the HTTPTask protocol.
     
     - Parameter urlRequest: A previously created URLRequest. If using a HTTP Request use the .urlRequest property to provide the request.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is true, if set false the task will be resumed automatically in this function. Default value is false and the task will be executed immediately.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the Task Protocol.
     */
    func createHTTPTask(urlRequest: URLRequest, startTaskManually: Bool, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask
    
    /**
     Sets the request delegate. Will be executed before the task is created and when the request is completed before the result is handled.
     - Parameter requestDelegate: An object that conforms to the RequestDelegate protocol.
     */
    func setRequestDelegate(requestDelegate: RequestDelegate)
    
    /**
     Removes the request delegate. Will not be executed anymore for all tasks started after removal.
     */
    func removeRequestDelegate()
    
}

extension HTTPClientCore {
    
    public func createRequest(relativeUrl: String, method: HttpRequestMethod, queryParameters: HttpQueryParameters? = nil, headers: HTTPHeaders? = nil, body: Data? = nil, cachePolicy: URLRequest.CachePolicy? = URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: TimeInterval? = HTTPHelper.DefaultRequestTimeout) -> HTTPRequest? {
        return createRequest(relativeUrl: relativeUrl, method: method, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    public func createRequest(absoluteUrl: URL, method: HttpRequestMethod, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data?, cachePolicy: URLRequest.CachePolicy? = URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: TimeInterval?) -> HTTPRequest {
        return createRequest(absoluteUrl: absoluteUrl,  method: method, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    public func createHTTPTask(urlRequest: URLRequest, startTaskManually: Bool = false, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask {
        return createHTTPTask(urlRequest: urlRequest, startTaskManually: startTaskManually, completionHandler: completionHandler)
    }
    
}
