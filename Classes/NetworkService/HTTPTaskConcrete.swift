//
//  HTTPTaskConcrete.swift
//  APLNetworkLayer
//
//  Created by apploft on 21.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation
import os

/// Handles a task and conforms to the HTTPTask protocol. Is a class because there would be problems with the variables of reference type being nil if it was a struct.
public class HTTPTaskConcrete: HTTPTask {
    
    /// Created session task
    public var urlSessionTask: URLSessionTask? {
        didSet {
            guard urlSessionTask != nil else {
                os_log("URLSessionTask that was set is nil!", log: customLog, type: .error)
                return
            }
            switch taskState {
            case .canceling:
                if urlSessionTask?.state != URLSessionTask.State.canceling {
                    urlSessionTask?.cancel()
                }
            case .pending:
                urlSessionTask?.resume()
                taskState = .running
            case .suspended:
                if urlSessionTask?.state != URLSessionTask.State.suspended {
                    urlSessionTask?.suspend()
                }
            default:
                ()
            }
            os_log("URLSessionTask with taskIdentifier %d has been set", log: customLog, type: .info, urlSessionTask?.taskIdentifier ?? -1)
        }
    }
    
    /// Identifier of the currently stored URL session task. Not a identifier for the HTTP task object itself.
    public var taskIdentifier: Int? {
        return urlSessionTask?.taskIdentifier
    }
    
    /// Priority of the currently stored URL session task. Will be applied to eventual retries of the request as well if a value is set.
    public var priority: Float? {
        get {
            return urlSessionTask?.priority
        }
        set {
            urlSessionTask?.priority = (newValue)!
        }
    }
    
    public func getState() -> HTTPTaskState {
        // Returns an internal property state as long as there is no URL task.
        if let state = urlSessionTask?.state {
            switch state {
            case .running:
                return HTTPTaskState.running
            case .suspended:
                return HTTPTaskState.suspended
            case .canceling:
                return HTTPTaskState.canceling
            case .completed:
                return HTTPTaskState.completed
            }
        } else {
            // urlSessionTask has not been set yet, return the internal taskState
            return self.taskState
        }
    }
    
   /// Completion handler for the task. Takes the response of the request or an error as parameter. Will be executed when the task of the request is completed.
    public var completionHandler: NetworkCompletionHandler
    
    /// HTTPResponse object that contains the URL response and data of a task.
    public var httpResponse: HTTPResponseConcrete?
    
    /// Counter for the retries that are done with this task
    public var retryCounter: Int = 0
    
    /**
     Initializer for HTTPTask. Takes a URLSessionTask object and a completion handler as parameters.
     - Parameter completionHandler: The completion handler that should be called when the task is completed. Takes the response as parameter or an error.
     */
    public init(completionHandler: @escaping NetworkCompletionHandler) {
        self.completionHandler = completionHandler
        taskState = .suspended
    }
    
    /**
     Initializer for HTTPTask. Takes a URLSessionTask object and a completion handler as parameters.
     - Parameter task: The created URLSesssion task. Optional parameter, can also be set later. 
     - Parameter completionHandler: The completion handler that should be called when the task is completed. Takes the response as parameter or an error.
     */
    public convenience init(task: URLSessionTask?, completionHandler: @escaping NetworkCompletionHandler) {
        self.init(completionHandler: completionHandler)
        self.urlSessionTask = task
    }
    
    public func resume() {
        if urlSessionTask != nil {
            urlSessionTask?.resume()
        } else {
            taskState = .pending
        }
    }
    
    public func cancel() {
        if urlSessionTask != nil {
            urlSessionTask?.cancel()
        }
        taskState = .canceling
    }
    
    public func suspend() {
        if urlSessionTask != nil {
            urlSessionTask?.suspend()
        }
        taskState = .suspended
    }
    
    /**
     Handles the received response of the task.
     - Parameter urlResponse:
     */
    public func didReceiveResponse(urlResponse: URLResponse) {
        os_log("Task with taskIdentifier %d did receive response", log: customLog, type: .info, urlSessionTask?.taskIdentifier ?? -1)
        httpResponse = HTTPResponseConcrete(urlResponse: urlResponse)
    }
    
    /**
     Handles the received data of the task.
     - Parameter data: Data that has been transmitted
     */
    public func didReceiveData(data: Data) {
        os_log("Task with taskIdentifier %d did receive data", log: customLog, type: .info, urlSessionTask?.taskIdentifier ?? -1)
        
        guard httpResponse != nil else {
            let message: StaticString = "Request completed without network errors but something went wrong, we didn't get a HTTPResponse!"
            os_log(message, log: customLog, type: .error)
            assertionFailure(message.description)
            return
        }
        
        if httpResponse?.data != nil {
            httpResponse?.data?.append(data)
        } else {
            httpResponse?.data = data
        }
    }
    
    /**
     Handles the task when completed and an eventually appearing error.
     - Parameter error: An Error object if the task was completed with an error. 
     */
    public func didCompleteWithError(error: Error?) {
        taskState = .completed
        
        if let error = error {
            os_log("Task with taskIdentifier %d did complete with error", log: customLog, type: .error, urlSessionTask?.taskIdentifier ?? -1)
            completionHandler(.failure(error))
            return
        } else {
            os_log("Task with taskIdentifier %d did complete without error", log: customLog, type: .info, urlSessionTask?.taskIdentifier ?? -1)
        }
        
        // check if the response is a HTTP response
        guard let httpResponse = httpResponse, (httpResponse.urlResponse as? HTTPURLResponse) != nil else {
            let message: StaticString = "Request completed without network errors but something went wrong, we didn't get a HTTPURLResponse!"
            os_log(message, log: customLog, type: .error)
            assertionFailure(message.description)
            
            completionHandler(.failure(HTTPHelper.genericError))
            return
        }
        
        completionHandler(.success(httpResponse))
    }
    
    //
    // MARK: - PRIVATE
    //
    
    /// State property to provide a value before a URL task has been set. Will be set to pending if the task.resume() had already been called
    private var taskState: HTTPTaskState = .suspended
    
    /// Logging subsystem for custom logging
    private static let logSubsystem = "de.apploft.networkapp.HTTPTaskConcrete"
    private let customLog = OSLog(subsystem: logSubsystem, category: "Task")
    
}
