//
//  HTTPClientConfigurationConcrete.swift
//  APLNetworkLayer
//
//  Created by apploft on 13.07.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation
import os

public final class HTTPClientConfigurationConcrete: HTTPClientConfiguration {
    public private(set) var objectCache: URLCache?
    public private(set) var baseURL: URL?
    public private(set) var urlSessionConfiguration: URLSessionConfiguration
    public private(set) var requestTimeout: TimeInterval = HTTPHelper.DefaultRequestTimeout
    
    /**
     Initializer for the HTTPClientConfiguration object using a configured URLSessionConfiguration.
     The caller is responsible to configure this session configuration accordingly as it will be
     taken as is.
     
     - Parameter baseURL: The URL that is the base for the later built and executed requests when the relative URL is provided. Optional parameter, but requests cannot be created with a relative URL without a base URL.
     - Parameter urlSessionConfiguration: A URLSessionConfiguration object that stores settings for the session such as the use of cellular data. Use URLSessionConfiguration.default to create your own configuration instead of new to avoid InvalidArgumentExceptions when setting properties.
    */
    public init?(baseURL: URL?, urlSessionConfiguration: URLSessionConfiguration) {
        
        if let url = baseURL {
            guard HTTPClientConfigurationConcrete.isAcceptedURL(url: url) else {
                os_log("Configuration could not be initialized. If you want to use a base URL, use a valid one (http or https scheme)! Invalid URL: %@", log: HTTPClientConfigurationConcrete.customLog, type: .error, url.absoluteString)
                return nil
            }
            self.baseURL = url
        }

        self.urlSessionConfiguration = urlSessionConfiguration
    }
    
    /**
     Convenience initializer for the HTTPClientConfiguration object. Creates a URLSession configuration with the defined parameters or uses default parameters if not specified.
     
     - Parameter baseUrl: The URL that is the base for the later built and executed requests when the relative URL is added. Optional parameter, but creating requests with relative URLs cannot be used without a base URL.
     - Parameter defaultHeader: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is an empty dictionary. Will be set for every request in the session.
     - Parameter requestTimeout: A timeout value in seconds that will be set for every request and is relevant when the request is executed. Not the request timeout value of the session! Optional parameter. A default value is set if not provided.
     - Parameter allowsCellularAccess: Set if in the session cellular access is allowed. Default value is true.
     - Parameter waitsForConnectivity: A Boolean value that indicates whether the session should wait for connectivity to become available, or fail immediately.Default value is true.
     - Paramter objectCache: A cache for object level caching.
     - Parameter requestCachePolicy: Cache policy of the URL request. Default is useProtocolCachePolicy.
     */
    public convenience init?(baseURL: URL?,
                             defaultHeader: HTTPHeaders?,
                             requestTimeout: TimeInterval,
                             allowsCellularAccess: Bool,
                             waitsForConnectivity: Bool,
                             objectCache: URLCache?,
                             requestCachePolicy: URLRequest.CachePolicy) {
        let urlSessionConfiguration = URLSessionConfiguration.default
        
        /// Set a timeout value starting when the task of the request is queued in the session with resume(). Not the task timeout itself. 
        urlSessionConfiguration.timeoutIntervalForRequest = HTTPHelper.URLSessionConfigDefaultTimeoutForRequestQueue
        urlSessionConfiguration.allowsCellularAccess = allowsCellularAccess
        urlSessionConfiguration.waitsForConnectivity = waitsForConnectivity
        urlSessionConfiguration.urlCache = objectCache
        urlSessionConfiguration.requestCachePolicy = requestCachePolicy

        var defaultHeaders: HTTPHeaders = [HTTPHelper.AcceptLanguageHeaderKey: HTTPHelper.defaultAcceptLanguageHeaderValue]

        if let defaultHeader = defaultHeader {
            defaultHeaders.merge(defaultHeader) { $1 }
        }

        urlSessionConfiguration.httpAdditionalHeaders = defaultHeaders

        self.init(baseURL: baseURL, urlSessionConfiguration: urlSessionConfiguration)

        self.requestTimeout = requestTimeout
    }
    
    /**
     HTTPClientConfiguration serves as factory to create HTTP requests. Creates a request of a relative URL. Can only be used if base URL was provided.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter method: The HTTP method of the request. Can be GET, POST, PUT or DELETE. Mandatory parameter.
     - Parameter queryParameter: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: The body of a POST or PUT request. Default value is nil.
     - Parameter cachePolicy: Cache policy of the URL request. Default is useProtocolCachePolicy.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An HTTP request with the provided parameters or default values.
     */
    public func request(relativeUrl: String,
                        method: HttpRequestMethod,
                        queryParameters: HttpQueryParameters? = nil,
                        headers: HTTPHeaders? = nil,
                        body: Data? = nil,
                        cachePolicy: URLRequest.CachePolicy? = nil,
                        timeoutInterval: TimeInterval? = nil) -> HTTPRequest? {
        
        guard let baseURL = baseURL else {
            let message: StaticString = "Tried to set relative URL but base URL has not been set! Use absolute URL or set base URL when creating the client configuration!"
            os_log(message, log: HTTPClientConfigurationConcrete.customLog, type: .error)
            assertionFailure(message.description)
            return nil
        }
        let url = baseURL.appendingPathComponent(relativeUrl, isDirectory: false)
        
        return request(absoluteUrl: url, method: method, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    /**
     HTTPClientConfiguration serves as factory to create HTTP requests. Creates a request of an absolute URL.
     
     - Parameter absoluteUrl: The absolute URL for the API call. Mandatory parameter.
     - Parameter method: The HTTP method of the request. Can be GET, POST, PUT or DELETE.
     - Parameter queryParameter: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: The body of a POST or PUT request. Default value is nil.
     - Parameter cachePolicy: Cache policy of the URL request. Default is useProtocolCachePolicy.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An HTTP request with the provided parameters or default values.
     */
    public func request(absoluteUrl: URL,
                        method: HttpRequestMethod,
                        queryParameters: HttpQueryParameters? = nil,
                        headers: HTTPHeaders? = nil,
                        body: Data? = nil,
                        cachePolicy: URLRequest.CachePolicy? = nil,
                        timeoutInterval: TimeInterval? = nil) -> HTTPRequest {
        
        assert(HTTPClientConfigurationConcrete.isAcceptedURL(url: absoluteUrl))
        
        switch method {
        case .GET:
            if body != nil {
                os_log("Something seems to be wrong. A body has been set in a GET request!", log: HTTPClientConfigurationConcrete.customLog, type: .debug)
            }
        case .POST, .PUT:
            if body == nil {
                os_log("Something seems to be wrong. No body has been set in a POST or PUT request!", log: HTTPClientConfigurationConcrete.customLog, type: .debug)
            }
        case .DELETE:
            // optional body
            ()
        }
        return HTTPRequestConcrete(url: absoluteUrl, method: method, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy ?? .useProtocolCachePolicy, timeoutInterval: timeoutInterval ?? requestTimeout)
    }
    
    //
    // MARK: PRIVATE
    //
    
    /// OSLog for custom logging
    private static let customLog = OSLog(subsystem: HTTPHelper.LogSubsystem, category: "APLNetworkLayer.ClientConfiguration")

    /**
     Checks if the url is valid and of http or https scheme.
     - Parameter url: The URL to check.
     - Returns: A Bool value indicating if the URL is accepted or not.
     */
    private static func isAcceptedURL(url: URL) -> Bool {
        guard let component = URLComponents(url: url, resolvingAgainstBaseURL: true), component.isHTTPScheme else {
            os_log("Something seems to be wrong. URL has not been acdepted: %@", log: customLog, type: .error, url.absoluteString)
            return false
        }
        return true
    }
}

