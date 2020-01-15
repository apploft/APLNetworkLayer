//
//  URLResponseExtension.swift
//  APLNetworkLayer
//
//  Created by apploft on 23.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

extension URLResponse {
    
    public var isHTTPURLResponse: Bool {
        return httpUrlResponse != nil 
    }
    
    public var httpUrlResponse: HTTPURLResponse? {
        return self as? HTTPURLResponse
    }
}
