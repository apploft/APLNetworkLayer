//
//  HTTPURLResponseExtension.swift
//  APLNetworkLayer
//
//  Created by apploft on 20.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

extension HTTPURLResponse {
    
    /// Informational status: the request was received, continuing process.
    public static let PendingStatusCodeRange = 100...199
    /// Successful request: the request was successfully received, understood, and accepted.
    public static let SuccessStatusCodeRange = 200...299
    /// Redirecting request: further action needs to be taken in order to complete the request.
    public static let RedirectStatusCodeRange = 300...399
    /// Client error: the request contains bad syntax or cannot be fulfilled.
    public static let ClientErrorStatusCodeRange = 400...499
    /// Server error: the server failed to fulfill an apparently valid request.
    public static let ServerErrorStatusCodeRange = 500...599
    
    public var isStatusPending: Bool {
        return HTTPURLResponse.PendingStatusCodeRange.contains(statusCode)
    }
    
    public var isStatusSuccess: Bool {
        return HTTPURLResponse.SuccessStatusCodeRange.contains(statusCode)
    }
    
    public var isStatusRedirect: Bool {
        return HTTPURLResponse.RedirectStatusCodeRange.contains(statusCode)
    }
    
    public var isStatusError: Bool {
        return isStatusClientError || isStatusServerError
    }
    
    public var isStatusClientError: Bool {
        return HTTPURLResponse.ClientErrorStatusCodeRange.contains(statusCode)
    }
    
    public var isStatusServerError: Bool {
        return HTTPURLResponse.ServerErrorStatusCodeRange.contains(statusCode)
    }
    
    
    /// Provides a key for the HTTPURLResponse object in the user info of the error
    public static let HTTPURLResponseKey = "HTTPURLResponseKey"
    
    /// Creates Error of HTTPURLResponse with the status code, localized description and the HTTPURLResponse object with the HTTPURLResponseKey as user info.
    public var makeError : Error {
        return NSError(domain: HTTPHelper.ErrorDomain,
                       code: statusCode,
                       userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: statusCode),
                                  HTTPURLResponse.HTTPURLResponseKey: self]) as Error
    }
    
}
