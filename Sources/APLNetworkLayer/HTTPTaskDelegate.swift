//
//  HTTPTaskDelegate.swift
//  APLNetworkLayer
//
//  Created by Tino Rachui on 03.12.19.
//

import Foundation


/// A delegate for httpTask-level events
public protocol HTTPTaskDelegate: AnyObject {

    /// Ask the delegate whether or not a certain request response should
    /// be cached or not.
    /// - Parameters: httpClient the HTTP client on which the request has
    /// been initiated
    /// - Parameters: httpTask the corresponding http task
    /// - Parameters: willCacheResponse the proposed cache entry
    /// - Parameters: completionHandler a completion handler to be called
    /// with the answer on whether to cache the proposed cache entry or not.

    func httpClient(_ httpClient: HTTPClient, httpTask: HTTPTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void)


    /// Informs the delegate that a httpTask is waiting for network
    /// connectivity, e.g. because the device is offline.
    /// - Parameters: httpClient the HTTP client on which the request has
    /// been initiated
    /// - Parameters: httpTask the corresponding http task
    func httpClient(_ httpClient: HTTPClient, httpTaskIsWaitingForConnectivity httpTask: HTTPTask)

    /// Requests credentials from the delegate in response to an authentication request from the remote server.
    /// - Parameters: httpTask the corresponding http task
    /// - Parameters: challenge  An object that contains the request for authentication.
    /// - Parameters: A handler that your delegate method must call.
    func httpClient(_ httpClient: HTTPClient,
                    httpTask: HTTPTask,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
}
