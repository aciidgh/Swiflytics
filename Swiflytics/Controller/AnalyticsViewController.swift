//
//  AnalyticsViewController.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 16/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

class AnalyticsViewController: UIViewController, StoryboardInstantiable {
    typealias ViewController = AnalyticsViewController
    static let storyboardID = "AnalyticsViewControllerID"
    
    var profile: GAPropertyProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
