//
//  HTTPFactory.swift
//  APLNetworkLayer
//
//  Created by apploft on 21.09.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

/// Factory class to create HTTP configuration and client objects.
public class HTTPFactory {
    
    /**
     Creates an HTTPClient object with a specified configuration.
     
     - Parameter configuration: A HTTPClientConfiguration object to store configuration and settings for the HTTPClient.
     - Parameter completionHandlerOperationQueue: Set if the completion handler operations should run on main queue etc.
     - Returns: An HTTPClient object.
     */
    public static func createClient(configuration: HTTPClientConfiguration, completionHandlerOperationQueue: OperationQueue? = nil) -> HTTPClient {
        return HTTPClientConcrete(configuration: configuration, completionHandlerOperationQueue: completionHandlerOperationQueue)
    }
    
    /**
     Creates an HTTPClientConfiguration object.
     
     - Parameter baseURL: The URL that is the base for the later built and executed requests when the relative URL is provided. Optional parameter, but requests cannot be created with a relative URL without a base URL.
     - Parameter urlSessionConfiguration: A URLSessionConfiguration object that stores settings for the session such as the use of cellular data. Use URLSessionConfiguration.default to create your own configuration instead of new to avoid InvalidArgumentExceptions when setting properties.
     - Returns: An HTTPClientConfiguration object. Can be nil if an invalid base URL is specified.
     */
    public static func createConfiguration(baseURL: URL? = nil,  urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default) -> HTTPClientConfiguration? {
        return HTTPClientConfigurationConcrete(baseURL: baseURL,  urlSessionConfiguration: urlSessionConfiguration)
    }
    
    /**
     Creates an HTTPClientConfiguration object. Creates a URLSession configuration with the defined parameters or uses default parameters if not specified.
     
     - Parameter baseURL: The URL that is the base for the later built and executed requests when the relative URL is added. Optional parameter, but creating requests with relative URLs cannot be used without a base URL.
     - Parameter defaultHeader: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil. Will be set for every request in the session.
     - Parameter requestTimeout: A timeout value in seconds that will be set for every request and is relevant when the request is executed. Not the request timeout value of the session! Optional parameter. A default value is set if not provided.
     - Parameter allowsCellularAccess: Set if in the session cellular access is allowed. Default value is true.
     - Parameter waitsForConnectivity: A Boolean value that indicates whether the session should wait for connectivity to become available, or fail immediately.Default value is true.
     - Returns: An HTTPClientConfiguration object. Can be nil if an invalid base URL is specified.
     */
    public static func createConfiguration(baseURL: URL? = nil, defaultHeader: HTTPHeaders? = nil, requestTimeout: TimeInterval = HTTPHelper.DefaultRequestTimeout, allowsCellularAccess: Bool = true, waitsForConnectivity: Bool = true, objectCache: URLCache? = nil, requestCachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) -> HTTPClientConfiguration? {
        return HTTPClientConfigurationConcrete(baseURL: baseURL, defaultHeader: defaultHeader, requestTimeout: requestTimeout, allowsCellularAccess: allowsCellularAccess, waitsForConnectivity: waitsForConnectivity, objectCache: objectCache, requestCachePolicy: requestCachePolicy)
    }    
}
