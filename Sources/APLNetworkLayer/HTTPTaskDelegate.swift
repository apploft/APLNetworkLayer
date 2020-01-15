//
//  HTTPTaskDelegate.swift
//  APLNetworkLayer
//
//  Created by Tino Rachui on 03.12.19.
//

import Foundation


/// A decision handler on whether or not to cache 'GET' request responses
public protocol HTTPTaskDelegate: class {

    /// Ask the delegate whether or not a certain request response should
    /// be cached or not.
    /// - Parameters: httpClient the HTTP client on which the request has
    /// been initiated
    /// - Parameters: httpTask the corresponding http task
    /// - Parameters: willCacheResponse the proposed cache entry
    /// - Parameters: completionHandler a completion handler to be called
    /// with the answer on whether to cache the proposed cache entry or not.

    func httpClient(_ httpClient: HTTPClient, httpTask: HTTPTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void)
}
