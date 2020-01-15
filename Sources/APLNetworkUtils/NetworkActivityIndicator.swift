//
//  NetworkActivitySharedIndicator.swift
//  Sample
//
//  Created by apploft on 15.01.2020.
//  Copyright © 2020 apploft GmbH. All rights reserved.

import UIKit
import Foundation

@available(iOSApplicationExtension, unavailable)
public class NetworkActivityIndicator {
    
    private static var numberOfActivities = 0
    
    public static func set(active: Bool) {
        
        DispatchQueue.main.async {
            
            if active {
                numberOfActivities += 1
            } else {
                numberOfActivities -= 1
            }
            
            if numberOfActivities < 0 {
                numberOfActivities = 0
            }

            UIApplication.shared.isNetworkActivityIndicatorVisible = (numberOfActivities > 0)
        }
    }
}
