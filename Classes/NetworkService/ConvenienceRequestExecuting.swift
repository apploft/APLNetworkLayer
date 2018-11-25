//
//  ConvenienceRequestExecuting.swift
//  APLNetworkLayer
//
//  Created by apploft on 18.09.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

/// Contains covenience methods to create and execute GET, POST, PUT and DELETE requests.
public protocol ConvenienceRequestExecuting {
    
    /**
     Convenience Method. Takes at least a relative URL and a completion Handler as parameter and creates a HTTP GET request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is not started automatically by default. Set startTaskManually to false to start the task immediately.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol. HTTPTask is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    func GET(relativeUrl: String, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?, startTaskManually: Bool, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask?
    
    /**
     Convenience Method. Takes at least an absolute URL and a completion Handler as parameter and creates a HTTP GET request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol.
     */
    func GET(absoluteUrl: URL, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?, startTaskManually: Bool, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask
    
    /**
     Convenience Method. Takes at least a relative URL, a body and a completion Handler as parameter and creates a HTTP POST request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a POST request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol. HTTPTask is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    func POST(relativeUrl: String, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?, startTaskManually: Bool, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask?
    
    /**
     Convenience Method. Takes at least an absolute URL, a body and a completion Handler as parameter and creates a HTTP POST request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a POST request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol.
     */
    func POST(absoluteUrl: URL, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?, startTaskManually: Bool, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask
    
    /**
     Convenience Method. Takes at least a relative URL, a body and a completion Handler as parameter and creates a HTTP PUT request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a PUT request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol. HTTPTask is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    func PUT(relativeUrl: String, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?, startTaskManually: Bool, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask?
    
    /**
     Convenience Method. Takes at least an absolute URL, a body and a completion Handler as parameter and creates a HTTP PUT request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a PUT request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol.
     */
    func PUT(absoluteUrl: URL, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?, startTaskManually: Bool, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask
    
    /**
     Convenience Method. Takes at least a relative URL and a completion Handler as parameter and creates a HTTP DELETE request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, can be provided for DELETE request, but is not necessary.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol. HTTPTask is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    func DELETE(relativeUrl: String, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?, startTaskManually: Bool, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask?
    
    /**
     Convenience Method. Takes at least an absolute URL and a completion Handler as parameter and creates a HTTP DELETE request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, can be provided for DELETE request, but is not necessary.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol.
     */
    func DELETE(absoluteUrl: URL, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?, startTaskManually: Bool, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask
    
}

extension ConvenienceRequestExecuting where Self: HTTPClientCore & ConvenienceRequestCreating {
    
    /**
     Convenience Method. Takes at least a relative URL and a completion Handler as parameter and creates a HTTP GET request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol. HTTPTask is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    public func GET(relativeUrl: String,
                    queryParameters: HttpQueryParameters? = nil,
                    headers: HTTPHeaders? = nil,
                    cachePolicy: URLRequest.CachePolicy? = nil,
                    timeoutInterval: TimeInterval? = nil,
                    startTaskManually: Bool = false,
                    completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask? {
        guard let request = GETRequest(relativeUrl: relativeUrl, queryParameters: queryParameters, headers: headers, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval) else {
            return nil
        }
        return createHTTPTask(urlRequest: request.urlRequest, startTaskManually: startTaskManually, completionHandler: completionHandler)
    }
    
    /**
     Convenience Method. Takes at least an absolute URL and a completion Handler as parameter and creates a HTTP GET request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol.
     */
    public func GET(absoluteUrl: URL,
                    queryParameters: HttpQueryParameters? = nil,
                    headers: HTTPHeaders? = nil,
                    cachePolicy: URLRequest.CachePolicy? = nil,
                    timeoutInterval: TimeInterval? = nil,
                    startTaskManually: Bool = false,
                    completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask {
        let request = GETRequest(absoluteUrl: absoluteUrl, queryParameters: queryParameters, headers: headers, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        return createHTTPTask(urlRequest: request.urlRequest, startTaskManually: startTaskManually, completionHandler: completionHandler)
    }
    
    /**
     Convenience Method. Takes at least a relative URL, a body and a completion Handler as parameter and creates a HTTP POST request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a POST request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol. HTTPTask is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    public func POST(relativeUrl: String,
                     queryParameters: HttpQueryParameters? = nil,
                     headers: HTTPHeaders? = nil,
                     body: Data,
                     cachePolicy: URLRequest.CachePolicy? = nil,
                     timeoutInterval: TimeInterval? = nil,
                     startTaskManually: Bool = false,
                     completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask? {
        guard let request = POSTRequest(relativeUrl: relativeUrl, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval) else {
            return nil
        }
        return createHTTPTask(urlRequest: request.urlRequest, startTaskManually: startTaskManually, completionHandler: completionHandler)
    }
    
    /**
     Convenience Method. Takes at least an absolute URL, a body and a completion Handler as parameter and creates a HTTP POST request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a POST request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol.
     */
    public func POST(absoluteUrl: URL,
                     queryParameters: HttpQueryParameters? = nil,
                     headers: HTTPHeaders? = nil,
                     body: Data,
                     cachePolicy: URLRequest.CachePolicy? = nil,
                     timeoutInterval: TimeInterval? = nil,
                     startTaskManually: Bool = false,
                     completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask {
        let request = POSTRequest(absoluteUrl: absoluteUrl, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        return createHTTPTask(urlRequest: request.urlRequest, startTaskManually: startTaskManually, completionHandler: completionHandler)
    }
    
    /**
     Convenience Method. Takes at least a relative URL, a body and a completion Handler as parameter and creates a HTTP PUT request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a PUT request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol. HTTPTask is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    public func PUT(relativeUrl: String,
                    queryParameters: HttpQueryParameters? = nil,
                    headers: HTTPHeaders? = nil,
                    body: Data,
                    cachePolicy: URLRequest.CachePolicy? = nil,
                    timeoutInterval: TimeInterval? = nil,
                    startTaskManually: Bool = false,
                    completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask? {
        guard let request = PUTRequest(relativeUrl: relativeUrl, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval) else {
            return nil
        }
        return createHTTPTask(urlRequest: request.urlRequest, startTaskManually: startTaskManually, completionHandler: completionHandler)
    }
    
    /**
     Convenience Method. Takes at least an absolute URL, a body and a completion Handler as parameter and creates a HTTP PUT request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a PUT request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol.
     */
    public func PUT(absoluteUrl: URL,
                    queryParameters: HttpQueryParameters? = nil,
                    headers: HTTPHeaders? = nil,
                    body: Data,
                    cachePolicy: URLRequest.CachePolicy? = nil,
                    timeoutInterval: TimeInterval? = nil,
                    startTaskManually: Bool = false,
                    completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask {
        let request = PUTRequest(absoluteUrl: absoluteUrl, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        return createHTTPTask(urlRequest: request.urlRequest, startTaskManually: startTaskManually, completionHandler: completionHandler)
    }
    
    /**
     Convenience Method. Takes at least a relative URL and a completion Handler as parameter and creates a HTTP DELETE request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, can be provided for DELETE request, but is not necessary.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol. HTTPTask is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    public func DELETE(relativeUrl: String,
                       queryParameters: HttpQueryParameters? = nil,
                       headers: HTTPHeaders? = nil,
                       body: Data? = nil,
                       cachePolicy: URLRequest.CachePolicy? = nil,
                       timeoutInterval: TimeInterval? = nil,
                       startTaskManually: Bool = false,
                       completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask? {
        guard let request = DELETERequest(relativeUrl: relativeUrl, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval) else {
            return nil
        }
        return createHTTPTask(urlRequest: request.urlRequest, startTaskManually: startTaskManually, completionHandler: completionHandler)
    }
    
    /**
     Convenience Method. Takes at least an absolute URL and a completion Handler as parameter and creates a HTTP DELETE request and task. Returns the task conforming to the HTTPTask protocol.
     Default values are provided if parameters are not set. Task is started automatically by default. Set startTaskManually to true to start the task manually.
     Use the convenience method if you don't want to make any changes to the created http or url request.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, can be provided for DELETE request, but is not necessary.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the HTTPTask protocol.
     */
    public func DELETE(absoluteUrl: URL,
                       queryParameters: HttpQueryParameters? = nil,
                       headers: HTTPHeaders? = nil,
                       body: Data? = nil,
                       cachePolicy: URLRequest.CachePolicy? = nil,
                       timeoutInterval: TimeInterval? = nil,
                       startTaskManually: Bool = false,
                       completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask {
        let request = DELETERequest(absoluteUrl: absoluteUrl, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        return createHTTPTask(urlRequest: request.urlRequest, startTaskManually: startTaskManually, completionHandler: completionHandler)
    }
    
}
