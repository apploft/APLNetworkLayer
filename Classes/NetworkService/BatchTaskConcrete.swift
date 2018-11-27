//
//  BatchTaskConcrete.swift
//  APLNetworkLayer
//
//  Created by apploft on 10.09.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation
import os

/// Class to create and execute batch requests.
public class BatchTaskConcrete: BatchTask {
    
    //
    // MARK: - BatchTask Protocol
    //
    
    public required init(client: HTTPClient, requests: [TaskIdentifier: HTTPRequest], completionHandler: @escaping BatchTaskCompletionHandler) {
        self.client = client
        self.completionHandler = completionHandler
        for (key, request) in requests {
            addRequest(httpRequest: request, withKey: key)
        }
    }
    
    public required init(client: HTTPClient, requests: [TaskIdentifier: URLRequest], completionHandler: @escaping BatchTaskCompletionHandler) {
        self.client = client
        self.completionHandler = completionHandler
        for (key, request) in requests {
            addRequest(urlRequest: request, withKey: key)
        }
    }
    
    //
    // MARK: - HTTPTaskActions Protocol
    //
    
    public func resume() {
        for task in tasks.values {
            task.resume()
        }
    }
    
    public func cancel() {
        for task in tasks.values {
            task.cancel()
        }
    }
    
    public func suspend() {
        for task in tasks.values {
            task.suspend()
        }
    }
    
    public func getTaskInfo(key: TaskIdentifier) -> HTTPTaskStateInfo? {
        var task: HTTPTaskStateInfo?
        doThreadSafe {
            task = tasks[key] 
        }
        return task
    }
    
    //
    // MARK: - PRIVATE
    //
    
    private let client: HTTPClient
    private var tasks = [TaskIdentifier: HTTPTask]()
    private var results = [TaskIdentifier: HTTPResult<HTTPResponse>]()
    
    /// Completion handler which will be executed after all tasks are completed.
    private let completionHandler: BatchTaskCompletionHandler
    
    /// OSLog for custom logging
    private static let customLog = OSLog(subsystem: HTTPHelper.LogSubsystem, category: "APLNetworkLayer.BatchRequest")
    
    /// Recursive lock for executing code thread safe.
    private var recursiveLock = NSRecursiveLock()
    
    /**
     Executes a code block thread safe.
     - Parameter block: A code block to execute thread safe.
     */
    private func doThreadSafe(block: () -> Void) {
        recursiveLock.lock()
        block()
        recursiveLock.unlock()
    }
    
    /**
     Adds an URL request to the batch request and creates the task.
     - Parameter urlRequest: The URL request to add to the batch request.
     - Parameter key: The key which will be used to save the corresponding task and result.
     */
    private func addRequest(urlRequest: URLRequest, withKey key: TaskIdentifier) {
        let task = client.createHTTPTask(urlRequest: urlRequest, startTaskManually: true) { (result: HTTPResult<HTTPResponse>) in
            var allResultsThere = false
            self.doThreadSafe {
                self.results[key] = result
                os_log("Result %d of %d of request \"%@\" arrived", log: BatchTaskConcrete.customLog, type: .info, self.results.count, self.tasks.count, key)
                
                allResultsThere = self.results.count == self.tasks.count
            }
            if allResultsThere {
                self.completionHandler(self.results)
                self.tasks.removeAll()
            }
        }
        
        doThreadSafe {
            tasks[key] = task
        }
    }
    
    /**
     Convenience method to add an HTTP request to the batch request. Can be used if nothing needs to be configured in the URL request and therefor the HTTP request does not need to be converted to URL request before.
     - Parameter httpRequest: The HTTP request to add to the batch request.
     - Parameter key: The key which will be used to save the corresponding task and result.
     */
    private func addRequest(httpRequest: HTTPRequest, withKey key: TaskIdentifier) {
        addRequest(urlRequest: httpRequest.urlRequest, withKey: key)
    }
    
}
