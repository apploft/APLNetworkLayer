//
//  URLRequestExtension.swift
//  APLNetworkLayer
//
//  Created by apploft on 20.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

extension URLRequest {
    
    /// Checks if the URL request is a GET request and returns a Bool.
    public var isGETRequest : Bool {
        return httpMethod?.lowercased() == "get"
    }
    
    /// Checks if the URL request is a POST request and returns a Bool.
    public var isPOSTRequest : Bool {
        return httpMethod?.lowercased() == "post"
    }
    
    /// Checks if the URL request is a PUT request and returns a Bool.
    public var isPUTRequest : Bool {
        return httpMethod?.lowercased() == "put"
    }
    
    /// Checks if the URL request is a DELETE request and returns a Bool.
    public var isDELETERequest : Bool {
        return httpMethod?.lowercased() == "delete"
    }
}
