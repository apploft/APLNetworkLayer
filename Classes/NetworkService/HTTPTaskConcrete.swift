//
//  HTTPTaskConcrete.swift
//  APLNetworkLayer
//
//  Created by apploft on 21.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation
import os


/// Handles a task and conforms to the HTTPTask protocol. Is a class because there would be problems
/// with the variables of reference type being nil if it was a struct.
public class HTTPTaskConcrete: HTTPTask {
    
    /// Created session task
    public var urlSessionTask: URLSessionTask? {
        didSet {
            if let urlSessionTask = self.urlSessionTask {
                let oldState = state
                state = URLSessionTaskState(urlSessionTask: urlSessionTask, defaults: oldState)
            } else {
                state = NoURLSessionTaskState()
            }
        }
    }
    
    public var urlRequest: URLRequest // TODO

    /// Identifier of the currently stored URL session task.
    /// Not a identifier for the HTTP task object itself.
    public var taskIdentifier: Int? {
        return urlSessionTask?.taskIdentifier
    }
    
    /// Priority of the currently stored URL session task. Will be applied to eventual retries of
    /// the request as well if a value is set.
    public var priority: Float {
        get {
            return state.priority
        }
        set {
            state.priority = newValue
        }
    }
    
    public func getState() -> HTTPTaskState {
        return state.taskState
    }
    
    /// Completion handler for the task. Takes the response of the request or an error as parameter.
    /// Will be executed when the task of the request is completed.
    public var completionHandler: NetworkCompletionHandler
    
    /// HTTPResponse object that contains the URL response and data of a task.
    public var httpResponse: HTTPResponseConcrete?
    
    /// Counter for the retries that are done with this task
    public var retryCounter: Int = 0
    
    /**
     Initializer for HTTPTask. Takes a URLSessionTask object and a completion handler as parameters.
     - Parameter task: The created URLSesssion task. Optional parameter, can also be set later.
     - Parameter completionHandler: The completion handler that should be called when the task is completed. Takes the response as parameter or an error.
     */
    public init(urlRequest: URLRequest, task: URLSessionTask? = nil, completionHandler: @escaping NetworkCompletionHandler) {
        self.urlRequest = urlRequest
        self.completionHandler = completionHandler
        self.urlSessionTask = task

        if let urlSessionTask = self.urlSessionTask {
            state = URLSessionTaskState(urlSessionTask: urlSessionTask)
        } else {
            state = NoURLSessionTaskState()
        }
    }
    
    public func resume() {
        state.resume()
    }
    
    public func cancel() {
        state.cancel()
    }
    
    public func suspend() {
        state.suspend()
    }
    
    /**
     Handles the received response of the task.
     - Parameter urlResponse:
     */
    public func didReceiveResponse(urlResponse: URLResponse) {
        os_log("HTTPTask with identifier %d did receive response '%{public}@", log: HTTPHelper.osLog, type: .debug, urlSessionTask?.taskIdentifier ?? -1, urlResponse.debugDescription)
        httpResponse = HTTPResponseConcrete(urlResponse: urlResponse)
    }
    
    /**
     Handles the received data of the task.
     - Parameter data: Data that has been transmitted
     */
    public func didReceiveData(data: Data) {
        guard httpResponse != nil else {
            let message: StaticString = "Request completed without network errors but something went wrong, we didn't get a HTTPResponse!"
            os_log(message, log: HTTPHelper.osLog, type: .error)
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
        if let error = error {
            os_log("HTTPTask with identifier %d did complete with error '%{public}@", log: HTTPHelper.osLog, type: .error, urlSessionTask?.taskIdentifier ?? -1, error.localizedDescription ?? "unknown")
            completionHandler(.failure(error))
            return
        } else {
            os_log("HTTPTask with identifier %d did complete without error", log: HTTPHelper.osLog, type: .info, urlSessionTask?.taskIdentifier ?? -1)
        }
        
        // check if the response is a HTTP response
        guard let httpResponse = httpResponse, (httpResponse.urlResponse as? HTTPURLResponse) != nil else {
            let message: StaticString = "Request completed without network errors but something went wrong, we didn't get a HTTPURLResponse!"
            os_log(message, log: HTTPHelper.osLog, type: .error)
            assertionFailure(message.description)
            
            completionHandler(.failure(HTTPHelper.genericError))
            return
        }
        
        completionHandler(.success(httpResponse))
    }
    //
    // MARK: - PRIVATE
    //
    private var state: URLSessionTaskStateAndPriority
}

//
//
protocol URLSessionTaskStateAndPriority {
    var priority: Float { get set }
    var taskState: HTTPTaskState { get set }
    
    func resume()
    func cancel()
    func suspend()
}

// A proxy to stand in when we still have no URLSessionTask object
//
class NoURLSessionTaskState: URLSessionTaskStateAndPriority {
    var priority: Float = URLSessionTask.defaultPriority
    /// State property to provide a value before a URL task has been set.
    // Will be set to pending if the task.resume() had already been called
    var taskState: HTTPTaskState = .suspended
    
    func resume() {
        taskState = .pending
    }
    
    func cancel() {
        taskState = .canceling
    }
    
    func suspend() {
        taskState = .suspended
    }
}

// A proxy when we have a URLSessionTask object
//
class URLSessionTaskState: URLSessionTaskStateAndPriority {
    var priority: Float {
        get {
            return urlSessionTask.priority
        }
        
        set {
            urlSessionTask.priority = newValue
        }
    }
    
    var taskState: HTTPTaskState {
        get {
            switch urlSessionTask.state {
            case .running:
                return HTTPTaskState.running
            case .suspended:
                return HTTPTaskState.suspended
            case .canceling:
                return HTTPTaskState.canceling
            case .completed:
                return HTTPTaskState.completed
            @unknown default:
                os_log("Task with identifier %d has unknown state. State pending is returned.",
                       log: HTTPHelper.osLog,
                       type: .info, urlSessionTask.taskIdentifier)
                return HTTPTaskState.pending
            }
        }
        
        set {}
    }
    
    init(urlSessionTask: URLSessionTask, defaults: URLSessionTaskStateAndPriority = NoURLSessionTaskState()) {
        self.urlSessionTask = urlSessionTask
        self.urlSessionTask.priority = defaults.priority
        
        switch defaults.taskState {
        case .canceling:
            if urlSessionTask.state != URLSessionTask.State.canceling {
                urlSessionTask.cancel()
            }
        case .pending:
            urlSessionTask.resume()
        case .suspended:
            if urlSessionTask.state != URLSessionTask.State.suspended {
                urlSessionTask.suspend()
            }
        default:
            break
        }
        
        os_log("HTTPTask with identifier %d created for request '%{public}@'",
               log: HTTPHelper.osLog,
               type: .info,
               urlSessionTask.taskIdentifier, urlSessionTask.currentRequest?.debugDescription ?? "unknown")
    }
    
    func resume() {
        urlSessionTask.resume()
    }
    
    func cancel() {
        urlSessionTask.cancel()
    }
    
    func suspend() {
        urlSessionTask.suspend()
    }
    
    private var urlSessionTask: URLSessionTask
}
