//
//  HTTPClientConcrete.swift
//  APLNetworkLayer
//
//  Created by apploft on 01.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import UIKit
import Foundation
import os

public class HTTPClientConcrete: NSObject, HTTPClient {
    
    public var completionHandlerOperationQueue: OperationQueue?
    public var maxRetries: Int = 3
    
    /**
     Initializer for HTTPClient. Takes a HTTPClientConfiguration object as parameter that provides settings for the client, session and requests.
     - Parameter configuration: A HTTPClientConfiguration object to store configuration and settings for the HTTPClient.
     - Parameter completionHandlerOperationQueue: Set if the completion handler operations should run on main queue etc. Default value is nil.
     */
    public init(configuration: HTTPClientConfiguration, completionHandlerOperationQueue: OperationQueue? = nil) {
        self.httpClientConfiguration = configuration
        self.completionHandlerOperationQueue = completionHandlerOperationQueue
    }
    
    /**
     Creates an HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration, and the HTTP method, which can be chosen of an enum. Calls the request method of the HTTPClientConfiguration to build the request. Can only be used if a base URL was provided in the configuration, will fail otherwise.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter method: The http method of the request. Can be GET, POST, PUT or DELETE from the enum HTTPMethods.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request. Only relevant for POST, PUT and eventually DELETE requests. Default is nil.
     - Parameter cachePolicy: Cache policy of the URL request. If not set, ProtocolCachePolicy will be set.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An object with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    public func createRequest(relativeUrl: String,
                              method: HttpRequestMethod,
                              queryParameters: HttpQueryParameters? = nil,
                              headers: HTTPHeaders? = nil,
                              body: Data? = nil,
                              cachePolicy: URLRequest.CachePolicy? = nil,
                              timeoutInterval: TimeInterval? = nil) -> HTTPRequest? {
        return httpClientConfiguration.request(relativeUrl: relativeUrl, method: method, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    /**
     Creates an HTTP Request with the given parameters. Default values are provided for everything but the relative URL, which is added to the base URL from the client configuration, and the HTTP method, which can be chosen of an enum. Calls the request method of the HTTPClientConfiguration to build the request.
     
     - Parameter relativeUrl: The relative URL to the configured base URL for the API call. Mandatory parameter.
     - Parameter method: The http method of the request. Can be GET, POST, PUT or DELETE from the enum HTTPMethods.
     - Parameter queryParameters: A dictionary of type [String: String] that contains the query parameters. Default value is nil.
     - Parameter headers: A dictionary of type [AnyHashable: Any] that contains the headers. Default value is nil.
     - Parameter body: Body of the request. Only relevant for POST, PUT and eventually DELETE requests. Default is nil.
     - Parameter cachePolicy: Cache policy of the URL request. If not set, ProtocolCachePolicy will be set.
     - Parameter timeoutInterval: The timeout interval for this particular request. If not set the value set in the HTTPClientConfiguration will be used.
     
     - Returns: An object with the given parameters that conforms to the HTTPRequest protocol. Can be converted to an URL request by using the .urlRequest property.
     */
    public func createRequest(absoluteUrl: URL,
                              method: HttpRequestMethod,
                              queryParameters: HttpQueryParameters? = nil,
                              headers: HTTPHeaders? = nil,
                              body: Data? = nil,
                              cachePolicy: URLRequest.CachePolicy? = nil,
                              timeoutInterval: TimeInterval? = nil) -> HTTPRequest {
        return httpClientConfiguration.request(absoluteUrl: absoluteUrl, method: method, queryParameters: queryParameters, headers: headers, body: body, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    
    /**
     Takes an URLRequest as a parameter and executes it. Creates and resumes a task with the URLSession in the process which is saved in a directory and returns the task conforming to the HTTPTask protocol.
     
     - Parameter urlRequest: A previously created URLRequest. If using a HTTP Request use the .urlRequest property to provide the request.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is true, if set false the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the Task Protocol.
     */
    public func createHTTPTask(urlRequest: URLRequest, startTaskManually: Bool = true, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask {
        let httpTask = HTTPTaskConcrete(urlRequest: urlRequest, completionHandler: completionHandler)
        addTaskThreadSafe(httpTask: httpTask)
        os_log("HTTPTask with URLSessionTask was created.", log: customLog, type: .info)
        prepareTaskForStart(httpTask: httpTask, startTaskManually: startTaskManually)
        return httpTask
    }
    
    public func addRequestDelegate(requestDelegate: RequestDelegate) {
        doThreadSafe {
            requestDelegates.append(requestDelegate)
        }
    }
    
    public func removeRequestDelegate(requestDelegate: RequestDelegate) {
        if let index = requestDelegates.index(where: { $0 === requestDelegate }) {
            doThreadSafe {
                requestDelegates.remove(at: index)
            }
        }
    }
    
    /**
     
     - Parameter httpTask:
     - Parameter startTaskManually:
     
     */
    private func prepareTaskForStart(httpTask: HTTPTaskConcrete, startTaskManually: Bool) {
        if requestDelegates.isEmpty {
            createURLSessionTask(httpTask: httpTask, startTaskManually: startTaskManually)
        } else {
            var counter = 0
            
            for requestDelegate in requestDelegates {
                requestDelegate.didCreateRequest(httpTask: httpTask) { () in
                    // TODO use alternative of OSAtomicIncrement32(&value)
                    doThreadSafe {
                        counter += 1
                    }
                    
                    if counter == requestDelegates.count {
                        createURLSessionTask(httpTask: httpTask, startTaskManually: startTaskManually)
                    }
                }
            }
        }
    }
    

    //
    // MARK: - PRIVATE
    //
    
    /// A HTTPClientConfiguration object to store the configuration and settings for the HTTPClient.
    private let httpClientConfiguration: HTTPClientConfiguration
    
    /// A URLSession object to handle communication with a server. Lazy because it uses the HTTPClient itself as a delegate which has to be initialized before. 
    private lazy var urlSession: URLSession = URLSession(configuration: self.httpClientConfiguration.urlSessionConfiguration, delegate: self, delegateQueue: nil)
    
    /// An array of http tasks which are currently in use (running, suspended, retried etc) and not completed yet.
    private var httpTasks = [HTTPTaskConcrete]()
    
    /// Array of request delegates which are called before the request is executed and when the result is handled.
    private var requestDelegates = [RequestDelegate]()
    
    /// Logging subsystem for custom logging
    private static let logSubsystem = "de.apploft.network.Client"
    private let customLog = OSLog(subsystem: logSubsystem, category: "Client")
    
    /**
     Executes a code block thread safe.
     - Parameter block: A code block to execute thread safe.
     */
    private func doThreadSafe(block: () -> Void) {
        recursiveLock.lock()
        block()
        recursiveLock.unlock()
    }
    
    /// Recursive lock for executing code thread safe.
    private var recursiveLock = NSRecursiveLock()
    
    /**
     Gets the task thread safely of the array.
     - Parameter taskIdentifier: The identifier of the task to find in the array.
     - Returns: The task if found in the array.
     */
    private func getTaskThreadSafe(taskIdentifier: Int) -> HTTPTaskConcrete? {
        var httpTask: HTTPTaskConcrete?
        doThreadSafe {
            guard let index = findTaskInArray(taskIdentifier: taskIdentifier) else {
                os_log("Task with taskIdentifier %d was not found in array", log: customLog, type: .error, taskIdentifier)
                return
            }
            httpTask = httpTasks[index]
        }
        return httpTask
    }
    
    /**
     Adds the an HTTP task thread safely to the array.
     - Parameter httpTask: the task to add to the array.
     */
    private func addTaskThreadSafe(httpTask: HTTPTaskConcrete) {
        doThreadSafe {
            httpTasks.append(httpTask)
        }
    }
    
    /**
     Removes the task thread safely of the array.
     - Parameter taskIdentifier: The identifier of the task to delete of the array.
     */
    private func deleteTaskThreadSafe(taskIdentifier: Int) {
        doThreadSafe {
            guard let index = findTaskInArray(taskIdentifier: taskIdentifier) else {
                os_log("Task with taskIdentifier %d was not found in array", log: customLog, type: .error, taskIdentifier)
                return
            }
            httpTasks.remove(at: index)
        }
    }
    
    /**
     Finds the http task containing the URL session task with the task identifier in the array and returns the index of the object.
     - Parameter taskIdentifier: The identifier of the task to find in the array.
     - Returns: The index of the task if found in the array.
     */
    private func findTaskInArray(taskIdentifier: Int) -> Int? {
        return httpTasks.index(where: { $0.taskIdentifier == taskIdentifier })
    }
    
    /**
     Creates a URLSessionTask with the given URL request and saves it in the given HTTP task object.
     - Parameter httpTask: The HTTP task object that will hold the URL session task.
     - Parameter with: URL request to create the URL session task.
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. If set false the task will be resumed automatically in this function.
     - Parameter priority: The priority the task will be executed with. If not set URLSessionTask.defaultPriority will be set.
     */
    private func createURLSessionTask(httpTask: HTTPTaskConcrete, startTaskManually: Bool, priority: Float = URLSessionTask.defaultPriority) {
        let urlSessionTask = urlSession.dataTask(with: httpTask.urlRequest)
        urlSessionTask.priority = priority
        httpTask.urlSessionTask = urlSessionTask
        
        os_log("URLSessionTask was created.", log: customLog, type: .info)
        
        if !startTaskManually {
            httpTask.resume()
        }
    }
    
}


// MARK: - URL Session Delegate 

/// HTTPClient serves as URLSessionDataDelegate
extension HTTPClientConcrete: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {            
        guard let httpTask = getTaskThreadSafe(taskIdentifier: dataTask.taskIdentifier) else {
            
            let message: StaticString = "Problem in didReceiveResponse: HTTP Task is nil and contained URLSessionTask with taskIdentifier %d was not found! Task will be canceled."
            os_log(message, log: customLog, type: .error, dataTask.taskIdentifier)
            assertionFailure(String(format: message.description, dataTask.taskIdentifier))
            
            completionHandler(URLSession.ResponseDisposition.cancel)
            return
        }
        
        httpTask.didReceiveResponse(urlResponse: response)
        // TODO check size to become download task if too big
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let httpTask = getTaskThreadSafe(taskIdentifier: dataTask.taskIdentifier) else {
            
            let message: StaticString = "Problem in didReceiveData: HTTP Task is nil and contained URLSessionTask with taskIdentifier %d was not found! Task will be canceled."
            os_log(message, log: customLog, type: .error, dataTask.taskIdentifier)
            assertionFailure(String(format: message.description, dataTask.taskIdentifier))
            return
        }

        httpTask.didReceiveData(data: data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) { 
        guard let httpTask = getTaskThreadSafe(taskIdentifier: task.taskIdentifier) else {
            
            let message: StaticString = "Problem in didCompleteWithError: HTTP Task is nil and contained URLSessionTask with taskIdentifier %d was not found! Task will be canceled."
            os_log(message, log: customLog, type: .error, task.taskIdentifier)
            assertionFailure(String(format: message.description, task.taskIdentifier))
            return
        }
        
        httpTask.retryCounter += 1
        
        if (requestDelegates.isEmpty) {
            complete(httpTask: httpTask, error: error)
            return
        }
        var retry = false
        var counter = 0
        for requestDelegate in requestDelegates {
            requestDelegate.didCompleteRequest(httpResponse: httpTask.httpResponse, error: error) { shouldRetry in
                // TODO use alternative of OSAtomicIncrement32(&value)
                doThreadSafe {
                    counter += 1
                }
                if shouldRetry && httpTask.retryCounter < maxRetries {
                    retry = true
                }
                
                if counter == requestDelegates.count {
                    if retry {
                        os_log("Request should be retried: %@", log: customLog, type: .info, httpTask.urlRequest.url?.absoluteString ?? "URL cannot be accessed")
                        prepareTaskForStart(httpTask: httpTask, startTaskManually: false) // TODO remove startTaskManually when default is changed to false
                    } else {
                        complete(httpTask: httpTask, error: error)
                    }
                }
            }
        }
        
    }
    
    /**
     Handles when the task is completed and will not be retried anymore.
     - Parameter httpTask: The task that has been completed.
     - Parameter error: An Error object if the task was completed with an error.
     */
    private func complete(httpTask: HTTPTaskConcrete, error: Error?) {
        if completionHandlerOperationQueue != nil {
            completionHandlerOperationQueue?.addOperation { httpTask.didCompleteWithError(error: error) }
        } else {
            httpTask.didCompleteWithError(error: error)
        }
        guard let taskIdentifier = httpTask.taskIdentifier else {
            os_log("Problem: there is apparently no task in the HTTPTask! URLSessionTask cannot be deleted from array.", log: customLog, type: .error)
            return
        }
        deleteTaskThreadSafe(taskIdentifier: taskIdentifier)
    }
}
