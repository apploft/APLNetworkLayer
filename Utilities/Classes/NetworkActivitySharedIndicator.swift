//
//  NetworkActivitySharedIndicator.swift
//  Sample
//
//  Created by Ahmet Akbal on 27.05.19.
//  Copyright © 2019 Ahmet Akbal. All rights reserved.
//
import UIKit

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
