//
//  BatchTask.swift
//  APLNetworkLayer
//
//  Created by apploft on 10.09.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

/// typealias for the batch request completion handler which takes a dictionary filled with TaskIdentifier and Result objects as parameter and returns Void.
public typealias BatchTaskCompletionHandler = ([TaskIdentifier: Result<HTTPResponse>]) -> Void

/// TaskIdentifier to later identify the result of the given request. Not to be confused with the task identifier of URLSessionTask or URLSessionDataTask.
public typealias TaskIdentifier = String

public protocol BatchTask : HTTPTaskActions {
    
    /**
     Initializer for batch request object. Takes HTTP requests as parameter. Use if you don't need to change properties in the URL requests before executing the requests.
     - Parameter client: HTTP client to execute the network calls.
     - Parameter requests: The dictionary of HTTP requests to be executed in this batch request.
     - Parameter completionHandler: A completion handler which will be executed when all requests of the batch request are completed.
     */
    init(client: HTTPClient, requests: [TaskIdentifier: HTTPRequest], completionHandler: @escaping BatchTaskCompletionHandler)
    
    /**
     Initializer for batch request object. Takes URL requests as parameter. Use if you need to change properties in the URL requests before executing the requests.
     - Parameter client: HTTP client to execute the network calls.
     - Parameter requests: The dictionary of URL requests to be executed in this batch request.
     - Parameter completionHandler: A completion handler which will be executed when all requests of the batch request are completed.
     */
    init(client: HTTPClient, requests: [TaskIdentifier: URLRequest], completionHandler: @escaping BatchTaskCompletionHandler)
 
    /**
     Get the task saved with given key that conforms to the HTTPTaskStateInfo protocol.
     - Parameter key: The key used for the request to find the corresponding task.
     - Returns: A task that conforms to HTTPTaskStateInfo if found in the dictionary.
     */
    func getTaskInfo(key: TaskIdentifier) -> HTTPTaskStateInfo?
}
