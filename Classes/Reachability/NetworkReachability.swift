//
//  NetworkReachability.swift
//  APLNetworkLayer
//
//  Created by apploft on 21.09.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//

import Foundation

/**
 Monitors the network's reachability. The current network status can be retrieved
 using the `NetworkReachability.shared.currentNetworkStatus` property.
 
 To be notified on status changes, add your receiver using `NetworkReachability.shared.addNetworkReachabilityObserver()`
 */
public class NetworkReachability {
    
    // MARK: - Public Interface
    
    public static let shared = NetworkReachability()
    
    public var currentNetworkStatus: NetworkStatus {
        return reachability.currentReachabilityStatus()
    }

    
    public func addNetworkReachabilityObserver(_ observer: NetworkReachabilityObserver) {
        observerArrayGuard.lock()
        networkReachabilityObservers.addPointer(observer.toOpaque())
        startObservationIfNecessary()
        observerArrayGuard.unlock()
    }
    
    
    // MARK: - Private Implementation
    
    fileprivate func startObservationIfNecessary() {
        guard observationStarted == false            else { return }
        guard networkReachabilityObservers.count > 0 else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNetworkReachabilityChangeNotification(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        reachability.startNotifier()
        observationStarted = true
    }
    
    fileprivate func stopObservationIfPossible() {
        guard observationStarted == true             else { return }
        guard networkReachabilityObservers.count > 0 else { return }
        
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
        observationStarted = false
    }
    
    @objc func didReceiveNetworkReachabilityChangeNotification(_ : NSNotification) {
        observerArrayGuard.lock()
        networkReachabilityObservers.compact()
        stopObservationIfPossible()
        let observers = networkReachabilityObservers.allObjects
        observerArrayGuard.unlock()
        
        let status = reachability.currentReachabilityStatus()
        for object in observers {
            if let observer = object as? NetworkReachabilityObserver {
                if status == .notReachable {
                    observer.networkDidBecomeUnreachable(withStatus: status)
                } else {
                    observer.networkDidBecomeReachable(withStatus: status)
                }
            }
        }
    }
    
    
    fileprivate let reachability = NetworkReachabilityImpl.reachabilityForInternetConnection()!
    fileprivate let networkReachabilityObservers = NSPointerArray.weakObjects()
    fileprivate let observerArrayGuard = NSRecursiveLock()
    fileprivate var observationStarted = false
    
}


fileprivate extension NetworkReachabilityObserver {
    
    fileprivate func toOpaque() -> UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(self as AnyObject).toOpaque()
    }
    
}
