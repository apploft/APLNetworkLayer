//
//  RequestDelegate.swift
//  APLNetworkLayer
//
//  Created by apploft on 28.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

/// Protocol for handling the requests before they were sent and after the request is completed before any completion handler is called. Implement Request delegate and add it to the client to execute it. 
public protocol RequestDelegate: class {
    
    /**
     Is executed before the URL request is executed in the HTTPClient. Call completion handler to proceed. 
     - Parameter urlRequest: The URL request that will be executed in the HTTPClient.
     */
    func didCreateRequest(urlRequest: URLRequest,  completionHandler: () -> Void)
    
    /**
     Is executed when the HTTPClient has received the result of the request before it is processed. Implement what needs to be executed or checked before the result is processed.
     - Parameter httpResponse: The HTTP response of the executed request.
     - Parameter error: An error if one occured when the request was executed.
     - Parameter completionHandler: A completion handler that is executed on the bool result of wheter to retry the request or not.
     - Returns: Return wheter to retry the request or not.
     */
    func didCompleteRequest(httpResponse: HTTPResponse?, error: Error?, completionHandler: (Bool) -> Void)
    
}
