//
//  HTTPRequestMethod.swift
//  APLNetworkLayer
//
//  Created by apploft on 15.01.2020.
//  Copyright © 2020 apploft GmbH. All rights reserved.

import Foundation

/// A convenience wrapper around an HTTPTask enabling PromiseKit-like
/// completion handler chaining like this:
/// HTTPClient.GET(...)
///   .statusCode(200) { ... }
///   .statusCode(401) { ... }
///   .statusCode(..<410) { ... }
///   .statusCode(500...599) { }
///   .anyStatusCode() { ...}
///   .catch { /* called on any error network or http status code within 400-599 */ }
///   .start()
public protocol HTTPRequestMethod {
    typealias StatusCode = Int
    typealias CompletionHandler = (Data?, HTTPURLResponse) -> Void
    typealias CompletionErrorHandler = (Data?, Error?, HTTPURLResponse?) -> Void
    typealias RangeType = ClosedRange<StatusCode>

    /// Start the http request
    func start()

    /// Register a completion handler for a specific status code
    /// - Parameters:
    ///   - code: the http status code
    ///   - handler: a completion handler being called when this status code is given
    func statusCode(_ code: StatusCode, handler: @escaping CompletionHandler) -> HTTPRequestMethod

    /// Register a completion handler for a range of status codes.
    /// - Parameters:
    ///   - range: the status code range
    ///   - handler: a completion handler being called when a status code in the range is given
    func statusCode(_ range: RangeType, handler: @escaping CompletionHandler) -> HTTPRequestMethod

    /// Register a completion handler for status codes starting from a specific range to open end
    /// - Parameters:
    ///   - range: the status code range
    ///   - handler: a completion handler being called when a matching status code is given
    func statusCode(_ range: PartialRangeFrom<StatusCode>, handler: @escaping CompletionHandler) -> HTTPRequestMethod


    /// Register a completion handler for status codes up the a specified status code.
    /// - Parameters:
    ///   - range: the status code range
    ///   - handler: a completion handler being called when a matching status code is given
    func statusCode(_ range: PartialRangeUpTo<StatusCode>, handler: @escaping CompletionHandler) -> HTTPRequestMethod

    /// Register a completion handler for all success status codes.
    /// - Parameter handler: the completion handler
    func statusCodeSuccess(handler: @escaping CompletionHandler) -> HTTPRequestMethod

    /// Register a completion handler for all client error status codes.
    /// - Parameter handler: the completion handler
    func statusCodeClientError(handler: @escaping CompletionHandler) -> HTTPRequestMethod

    /// Register a completion handler for all server error status code.
    /// - Parameter handler: the completion handler
    func statusCodeServerError(handler: @escaping CompletionHandler) -> HTTPRequestMethod

    /// Will be called if no other status code handler matches.
    ///
    /// - Parameter handler: the completion handler to call
    /// - Returns: Self
    func anyStatusCode(handler: @escaping CompletionHandler) -> HTTPRequestMethod

    /// Register a completion handler for any client or server error status code.
    /// - Parameter handler: the completion handler
    func `catch`(handler: @escaping CompletionErrorHandler) -> HTTPRequestMethod
}
