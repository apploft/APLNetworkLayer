//
//  HTTPClientConcrete.swift
//  APLNetworkLayer
//
//  Created by apploft on 01.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation
import os

public class HTTPClientConcrete: NSObject, HTTPClient {
    /// Request delegate that is called before the request is executed and when the result is handled. Is used as parameter for the created tasks and therefor bound to the task once created.
    public weak var requestDelegate: RequestDelegate?

    public weak var httpTaskDelegate: HTTPTaskDelegate?

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
     - Parameter startTaskManually: If set true the task needs to be resumed manually after calling this method. Default value is false, the task will be resumed automatically in this function.
     - Parameter completionHandler: A completion handler that takes a result of type HTTPResponse or an Error object.
     
     - Returns: A task object that implements the Task Protocol.
     */
    public func createHTTPTask(urlRequest: URLRequest, startTaskManually: Bool = false, completionHandler: @escaping NetworkCompletionHandler) -> HTTPTask {
        let httpTask = HTTPTaskConcrete(urlRequest: urlRequest, completionHandler: completionHandler)
        addTaskThreadSafe(httpTask: httpTask)
        os_log("HTTPTask was created.", log: HTTPHelper.osLog, type: .info)
        prepareTaskForStart(httpTask: httpTask, requestDelegate: self.requestDelegate, startTaskManually: startTaskManually)
        return httpTask
    }

    public func cancelAllTasks() {
        os_log("Cancelling all tasks...", log: HTTPHelper.osLog, type: .debug)

        doThreadSafe {
            self.httpTasks.forEach { $0.cancel() }
        }
    }

    /**
     
     - Parameter httpTask:
     - Parameter startTaskManually:
     
     */
    private func prepareTaskForStart(httpTask: HTTPTaskConcrete, requestDelegate: RequestDelegate? = nil, startTaskManually: Bool = false) {
        if let requestDelegate = requestDelegate {
            requestDelegate.didCreateRequest(urlRequest: httpTask.urlRequest) { result in
                switch result {
                case .success(let request):
                    httpTask.urlRequest = request
                    self.createURLSessionTask(httpTask: httpTask, startTaskManually: startTaskManually)

                case .failure(let error):
                    self.complete(httpTask: httpTask, error: error)
                }

            }
        } else {
            createURLSessionTask(httpTask: httpTask, startTaskManually: startTaskManually)
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
                os_log("Task with taskIdentifier %d was not found in array", log: HTTPHelper.osLog, type: .error, taskIdentifier)
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
            os_log("Adding task %d to task list.", log: HTTPHelper.osLog, type: .debug, httpTask.taskIdentifier ?? -1)
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
                os_log("Task with identifier %d was not found in task list", log: HTTPHelper.osLog, type: .error, taskIdentifier)
                return
            }

            os_log("Removing task %d from task list", log: HTTPHelper.osLog, type: .debug, taskIdentifier)
            httpTasks.remove(at: index)
        }
    }
    
    /**
     Finds the http task containing the URL session task with the task identifier in the array and returns the index of the object.
     - Parameter taskIdentifier: The identifier of the task to find in the array.
     - Returns: The index of the task if found in the array.
     */
    private func findTaskInArray(taskIdentifier: Int) -> Int? {
        return httpTasks.firstIndex(where: { $0.taskIdentifier == taskIdentifier })
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
        
        os_log("URLSessionTask for request '%{public}@' created.", log: HTTPHelper.osLog, type: .debug, httpTask.urlRequest.debugDescription)
        
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
            let message: StaticString = "Did receive response but could not find a corresponding task with identifier %d in task list! Task will be canceled."

            os_log(message, log: HTTPHelper.osLog, type: .error, dataTask.taskIdentifier)
            assertionFailure(String(format: String(describing: message), dataTask.taskIdentifier))
            
            completionHandler(URLSession.ResponseDisposition.cancel)
            return
        }
        
        httpTask.didReceiveResponse(urlResponse: response)

        // TODO check size to become download task if too big
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let httpTask = getTaskThreadSafe(taskIdentifier: dataTask.taskIdentifier) else {
            let message: StaticString = "Did receive data but could not find a corresponding task with identifier %d in task list!"

            os_log(message, log: HTTPHelper.osLog, type: .error, dataTask.taskIdentifier)
            assertionFailure(String(format: String(describing: message), dataTask.taskIdentifier))
            return
        }
        
        httpTask.didReceiveData(data: data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let httpTask = getTaskThreadSafe(taskIdentifier: task.taskIdentifier) else {
            
            let message: StaticString = "Request '%{public}@' did complete with error '%{public}@', but could not find a corresponding task with identifier %d in task list!"
            os_log(message, log: HTTPHelper.osLog, type: .error, task.currentRequest?.debugDescription ?? "unknown", error?.localizedDescription ?? "nil", task.taskIdentifier)
            assertionFailure(String(format: String(describing: message), task.taskIdentifier))
            return
        }
        
        httpTask.retryCounter += 1

        let callCompletionBlock = {
            os_log("Request '%{public}@' did complete with error '%{public}@'", log: HTTPHelper.osLog, type: .debug, task.currentRequest?.debugDescription ?? "unknown", error?.localizedDescription ?? "nil")
            self.complete(httpTask: httpTask, error: error)
        }

        if let requestDelegate = self.requestDelegate {
            requestDelegate.didCompleteRequest(httpResponse: httpTask.httpResponse, error: error) { shouldRetry in
                if shouldRetry && httpTask.retryCounter < self.maxRetries {
                    os_log("Request '%{public}@' should be retried", log: HTTPHelper.osLog, type: .info, httpTask.urlRequest.debugDescription)
                    self.prepareTaskForStart(httpTask: httpTask, requestDelegate: self.requestDelegate)
                } else {
                    callCompletionBlock()
                }
            }
        } else {
            callCompletionBlock()
        }
    }

    // MARK: - Cache Handling

    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        guard let httpTaskDelegate = self.httpTaskDelegate,
              let task = getTaskThreadSafe(taskIdentifier: dataTask.taskIdentifier) else {
            os_log("Agreed to cache response data for request %{public}@", log: HTTPHelper.osLog, type: .debug, dataTask.currentRequest?.debugDescription ?? "unknown")

            completionHandler(proposedResponse)
            return
        }

        httpTaskDelegate.httpClient(self, httpTask: task, willCacheResponse: proposedResponse, completionHandler: completionHandler)
    }

    // MARK: - Handling redirects

    public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        // Just perform the redirect
        completionHandler(request)
    }

    // MARK: - Connectivity Handling

    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        guard let httpTaskDelegate = self.httpTaskDelegate,
            let httpTask = getTaskThreadSafe(taskIdentifier: task.taskIdentifier) else {
            return
        }

        httpTaskDelegate.httpClient(self, httpTaskIsWaitingForConnectivity: httpTask)
    }

    /**
     Handles when the task is completed and will not be retried anymore.
     - Parameter httpTask: The task that has been completed.
     - Parameter error: An Error object if the task was completed with an error.
     */
    private func complete(httpTask: HTTPTaskConcrete, error: Error?) {
        let completionBlock = { httpTask.didCompleteWithError(error: error) }

        if completionHandlerOperationQueue != nil {
            completionHandlerOperationQueue?.addOperation(completionBlock)
        } else {
            completionBlock()
        }
        guard let taskIdentifier = httpTask.taskIdentifier else {
            os_log("Task with for request '%{public}@' has not identifier hence cannot be removed from task list", log: HTTPHelper.osLog, type: .error, httpTask.urlRequest.debugDescription)
            return
        }
        deleteTaskThreadSafe(taskIdentifier: taskIdentifier)
    }
}
