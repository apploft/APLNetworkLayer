//
//  URLComponentsExtension.swift
//  APLNetworkLayer
//
//  Created by apploft on 20.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

extension URLComponents {
    
    /// Checks if the scheme is HTTP or HTTPS and returns a Bool. 
    public var isHTTPScheme: Bool {
        return scheme == "http" || scheme == "https"
    }
    
}
