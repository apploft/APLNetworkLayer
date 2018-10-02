//
//  HTTPTask.swift
//  APLNetworkLayer
//
//  Created by apploft on 21.08.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//
import Foundation

public typealias HTTPTask = HTTPTaskActions & HTTPTaskStateInfo & HTTPTaskPriority

/// Task state enum which provides the same states as URLSessionTask.State and additionally a pending state for when the task.resume() has been called before the URL session task was set.
public enum HTTPTaskState: Int {
    case running = 0
    case suspended = 1
    case canceling = 2
    case completed = 3
    case pending = 4
}

/// The task protocol holds a task object and saves the data received of the task. The task can be started or cancelled.
public protocol HTTPTaskActions: class {
    
    /// Starts the task. Resumes the task, if it is suspended.
    func resume()
    /// Cancel the task.
    func cancel()
    /// Temporarily suspends a task.
    func suspend()
}

public protocol HTTPTaskStateInfo: class {
    /// The current state of the task which can be running, suspended, in the process of being canceled, completed or pending.
    func getState() -> HTTPTaskState
}

public protocol HTTPTaskPriority: class {
    /// The relative priority at which a host should handle the task, specified as a floating point value between 0.0 (lowest priority) and 1.0 (highest priority).
    var priority: Float? { get set }
}
