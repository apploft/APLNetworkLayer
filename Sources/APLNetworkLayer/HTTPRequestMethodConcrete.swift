//
//  HTTPRequestMethodConcrete.swift
//  APLNetworkLayer
//
//  Created by apploft on 15.01.2020.
//  Copyright © 2020 apploft GmbH. All rights reserved.

import Foundation

class HTTPRequestMethodConcrete: HTTPRequestMethod {
    typealias NetworkErrorCompletionHandler = (Error?) -> Void

    var httpTask: HTTPTask?

    // MARK: - HTTPRequestMethod

    func start() {
        httpTask?.resume()
    }

    func statusCode(_ code: StatusCode, handler: @escaping CompletionHandler) -> HTTPRequestMethod {
       statusCodeHandler[code...code] = handler
       return self
    }

    func statusCode(_ range: RangeType, handler: @escaping CompletionHandler) -> HTTPRequestMethod {
        statusCodeHandler[range] = handler
        return self
    }

    func statusCode(_ range: PartialRangeFrom<StatusCode>, handler: @escaping CompletionHandler) -> HTTPRequestMethod {
        let lower = range.lowerBound
        let upper = upperBoundFittingLower(lower)
        let closedRange = ClosedRange(uncheckedBounds: (lower, upper))

        statusCodeHandler[closedRange] = handler
        return self
    }

    func statusCode(_ range: PartialRangeUpTo<StatusCode>, handler: @escaping CompletionHandler) -> HTTPRequestMethod {
        let upper = range.upperBound
        let lower = lowerBoundFittingUpper(upper)
        let closedRange = ClosedRange(uncheckedBounds: (lower, upper))

        statusCodeHandler[closedRange] = handler

        return self
    }

    func statusCodeSuccess(handler: @escaping CompletionHandler) -> HTTPRequestMethod {
        return statusCode(200...299, handler: handler)
    }

    func statusCodeClientError(handler: @escaping CompletionHandler) -> HTTPRequestMethod {
        return statusCode(400...499, handler: handler)
    }

    func statusCodeServerError(handler: @escaping CompletionHandler) -> HTTPRequestMethod {
        return statusCode(500...599, handler: handler)
    }

    /// Will be called if no other status code handler matches.
    ///
    /// - Parameter handler: the completion handler to call
    /// - Returns: Self
    func anyStatusCode(handler: @escaping CompletionHandler) -> HTTPRequestMethod {
        onAnyStatusCodeHandler = handler
        return self
    }

    func `catch`(handler: @escaping CompletionErrorHandler) -> HTTPRequestMethod {
        catchErrorHandler = handler
        return self
    }

    func onNetworkError(handler: @escaping NetworkErrorCompletionHandler) -> HTTPRequestMethod {
        onNetworkErrorHandler = handler
        return self
    }

    func callStatusCodeHandler(_ httpResponse: HTTPResponse) {
        let httpUrlResponse = httpResponse.urlResponse as! HTTPURLResponse
        let statusCode = httpUrlResponse.statusCode
        var hasExecutedSpecificStatusCodeHandler = false

        for (r, h) in statusCodeHandler {
            if r.contains(statusCode) {
                hasExecutedSpecificStatusCodeHandler = true
                h(httpResponse.data, httpUrlResponse)
                break
            }
        }

        if !hasExecutedSpecificStatusCodeHandler {
            if HttpStatusCodeErrorRange.contains(statusCode) {
                catchErrorHandler?(httpResponse.data, nil, httpUrlResponse)
            } else {
                onAnyStatusCodeHandler?(httpResponse.data, httpUrlResponse)
            }
        }
    }

    // MARK: - Private

    private func upperBoundFittingLower(_ lower: Int) -> Int {
        switch lower {
        case ..<100: return 99
        case ..<200: return 199
        case ..<300: return 299
        case ..<400: return 399
        case ..<500: return 499
        default: return 599
        }
    }

    private func lowerBoundFittingUpper(_ upper: Int) -> Int {
        switch upper {
        case ..<100: return 0
        case ..<200: return 100
        case ..<300: return 200
        case ..<400: return 300
        case ..<500: return 400
        case ..<600: return 500
        default: return 500
        }
    }

    private let HttpStatusCodeErrorRange = 400...599

    private var statusCodeHandler: [RangeType: CompletionHandler] = [:]
    private var onAnyStatusCodeHandler: CompletionHandler?
    private (set) var onNetworkErrorHandler: NetworkErrorCompletionHandler?
    private (set) var catchErrorHandler: CompletionErrorHandler?
}
