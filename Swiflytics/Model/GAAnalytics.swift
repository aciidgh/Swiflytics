//
//  GAAnalytics.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 16/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

struct GAAnalytics {
    
    let dimension: AnalyticsDimension
    let metric: AnalyticsMetric
    
    let dimensionValues: [String]
    let metricValues: [String]
    
    var count: Int {
        return dimensionValues.count
    }
}


