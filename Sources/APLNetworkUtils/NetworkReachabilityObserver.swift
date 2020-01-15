//
//  NetworkReachabilityObserver.swift
//  APLNetworkLayer
//
//  Created by apploft on 21.09.18.
//  Copyright © 2018 de.apploft. All rights reserved.
//

import Foundation
import NetworkReachability

/**
Any object receiving network status updates must conform to this protocol.
 
Add your observer using `NetworkReachability.shared.addNetworkReachabilityObserver()`
 */
public protocol NetworkReachabilityObserver: class {
    func networkDidBecomeReachable(withStatus: NetworkStatus)
    func networkDidBecomeUnreachable(withStatus: NetworkStatus)
}
