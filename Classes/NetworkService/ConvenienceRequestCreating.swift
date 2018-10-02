//
//  ConvenienceRequestCreating.swift
//  APLNetworkLayer
//
//  Created by apploft on 18.09.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

/// Contains covenience methods to create GET, POST, PUT and DELETE requests.
public protocol ConvenienceRequestCreating {
    
    /**
     Creates a GET HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters. Can only be used if a base URL was provided in the configuration, will fail otherwise.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: A GET request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property. Is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    func GETRequest(relativeUrl: String, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest?
    /**
     Creates a GET HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters.
     
     - Parameter absoluteUrl:  The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: A GET request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    func GETRequest(absoluteUrl: URL, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest
    
    
    /**
     Creates a POST HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters. Can only be used if a base URL was provided in the configuration, will fail otherwise.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a POST request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: A POST request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property. Is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    func POSTRequest(relativeUrl: String, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest?
    
    /**
     Creates a POST HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a POST request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: A POST request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    func POSTRequest(absoluteUrl: URL, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest
    
    /**
     Creates a PUT HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters. Can only be used if a base URL was provided in the configuration, will fail otherwise.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a PUT request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An PUT request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property. Is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    func PUTRequest(relativeUrl: String, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest?
    
    /**
     Creates a PUT HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a PUT request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An PUT request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    func PUTRequest(absoluteUrl: URL, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest
    
    /**
     Creates a DELETE HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters. Can only be used if a base URL was provided in the configuration, will fail otherwise.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, can be provided for DELETE request, but is not necessary.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An DELETE request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property. Is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    func DELETERequest(relativeUrl: String, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest?
    
    /**
     Creates a DELETE HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, can be provided for DELETE request, but is not necessary.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An DELETE request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    func DELETERequest(absoluteUrl: URL, queryParameters: HttpQueryParameters?, headers: HTTPHeaders?, body: Data?, cachePolicy: URLRequest.CachePolicy?, timeoutInterval: TimeInterval?) -> HTTPRequest
    
}

extension ConvenienceRequestCreating where Self: HTTPClientCore {
    
    /**
     Creates a GET HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters. Can only be used if a base URL was provided in the configuration, will fail otherwise.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: A GET request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property. Is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    public func GETRequest(relativeUrl: String,
                           queryParameters: HttpQueryParameters? = nil,
                           headers: HTTPHeaders? = nil,
                           cachePolicy: URLRequest.CachePolicy? = nil,
                           timeoutInterval: TimeInterval? = nil) -> HTTPRequest? {
        return createRequest(relativeUrl: relativeUrl, method: .GET, queryParameters: queryParameters, headers: headers, body: nil, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    /**
     Creates a GET HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters.
     
     - Parameter absoluteUrl:  The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: A GET request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    public func GETRequest(absoluteUrl: URL,
                           queryParameters: HttpQueryParameters? = nil,
                           headers: HTTPHeaders? = nil,
                           cachePolicy: URLRequest.CachePolicy? = nil,
                           timeoutInterval: TimeInterval? = nil) -> HTTPRequest {
        return createRequest(absoluteUrl: absoluteUrl, method: .GET, queryParameters: queryParameters, headers: headers, body: nil, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    
    /**
     Creates a POST HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters. Can only be used if a base URL was provided in the configuration, will fail otherwise.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a POST request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: A POST request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property. Is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    public func POSTRequest(relativeUrl: String,
                            queryParameters: HttpQueryParameters? = nil,
                            headers: HTTPHeaders? = nil,
                            body: Data,
                            cachePolicy: URLRequest.CachePolicy? = nil,
                            timeoutInterval: TimeInterval? = nil) -> HTTPRequest? {
        return createRequest(relativeUrl: relativeUrl, method: .POST, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    /**
     Creates a POST HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a POST request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: A POST request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    public func POSTRequest(absoluteUrl: URL,
                            queryParameters: HttpQueryParameters? = nil,
                            headers: HTTPHeaders? = nil,
                            body: Data,
                            cachePolicy: URLRequest.CachePolicy? = nil,
                            timeoutInterval: TimeInterval? = nil) -> HTTPRequest {
        return createRequest(absoluteUrl: absoluteUrl, method: .POST, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    /**
     Creates a PUT HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters. Can only be used if a base URL was provided in the configuration, will fail otherwise.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a PUT request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An PUT request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property. Is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    public func PUTRequest(relativeUrl: String,
                           queryParameters: HttpQueryParameters? = nil,
                           headers: HTTPHeaders? = nil,
                           body: Data,
                           cachePolicy: URLRequest.CachePolicy? = nil,
                           timeoutInterval: TimeInterval? = nil) -> HTTPRequest? {
        return createRequest(relativeUrl: relativeUrl, method: .PUT, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    /**
     Creates a PUT HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, has to be provided for a PUT request.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An PUT request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    public func PUTRequest(absoluteUrl: URL,
                           queryParameters: HttpQueryParameters? = nil,
                           headers: HTTPHeaders? = nil,
                           body: Data,
                           cachePolicy: URLRequest.CachePolicy? = nil,
                           timeoutInterval: TimeInterval? = nil) -> HTTPRequest {
        return createRequest(absoluteUrl: absoluteUrl, method: .PUT, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    /**
     Creates a DELETE HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters. Can only be used if a base URL was provided in the configuration, will fail otherwise.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, can be provided for DELETE request, but is not necessary.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An DELETE request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property. Is optional because creating a HTTP request is not possible if base URL is not specified.
     */
    public func DELETERequest(relativeUrl: String,
                              queryParameters: HttpQueryParameters? = nil,
                              headers: HTTPHeaders? = nil,
                              body: Data? = nil,
                              cachePolicy: URLRequest.CachePolicy? = nil,
                              timeoutInterval: TimeInterval? = nil) -> HTTPRequest? {
        return createRequest(relativeUrl: relativeUrl, method: .DELETE, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    /**
     Creates a DELETE HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration. Calls the create request method of the HTTPClient with the given parameters.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request, can be provided for DELETE request, but is not necessary.
     - Parameter cachePolicy: Cache policy of the URL request.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An DELETE request with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    public func DELETERequest(absoluteUrl: URL,
                              queryParameters: HttpQueryParameters? = nil,
                              headers: HTTPHeaders? = nil,
                              body: Data? = nil,
                              cachePolicy: URLRequest.CachePolicy? = nil,
                              timeoutInterval: TimeInterval? = nil) -> HTTPRequest {
        return createRequest(absoluteUrl: absoluteUrl, method: .DELETE, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
}
