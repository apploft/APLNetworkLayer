//
//  HTTPHelper.swift
//  APLNetworkLayer
//
//  Created by apploft on 17.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

/// Provides helper functions or properties for the network layer implementation.
public struct HTTPHelper {
    
    /// A generic error code to create a generic error.
    public static let GenericErrorCode: Int = 2000
    
    /// A generic error description to create a generic error.
    public static let GenericLocalizedErrorDescription: String = "An unknown error occurred"
    
    /// The default value for the timeout of the session configuration for the requests, which starts once resume() has been executed and the request has been put in the queue, not the actual execution of the request. Set to 1 hour. 
    public static let URLSessionConfigDefaultTimeoutForRequestQueue: TimeInterval = 3600.0
    
    /// Default timeout for the request for when the session task of the request is executed not queued.
    public static let DefaultRequestTimeout: TimeInterval = 60.0
    
    /// Error domain for custom created errors.
    public static let ErrorDomain: String = "de.apploft.networklayer"
    
    /// Creates a generic Error with a generic error code and description to use for unknown errors.
    public static var genericError: Error {
        return NSError(domain: HTTPHelper.ErrorDomain, code: GenericErrorCode, userInfo: [NSLocalizedDescriptionKey: GenericLocalizedErrorDescription])
    }
    
    /// Key for the header containing the accepted and preferred languages.
    public static let PreferredLanguagesKey: String = "Accept-Language"
    
    /// Creates the string with preferred languages that are saved in the device for the accept-language header.
    public static var acceptLanguageValue: String {
        let preferredLanguages = Locale.preferredLanguages
        var idx: Float = 0.0
        let val = preferredLanguages.reduce("") { (result, next) in
            let val = "\(next);q=\(1.0 - (idx * 0.1))"
            idx += 1
            return "\(result)\(result.isEmpty ? "" : ", ")\(val)"
        }
        return val
    }
    
    /// Logging subsystem for custom logging
    static let LogSubsystem = "de.apploft.networklayer"
    
}
