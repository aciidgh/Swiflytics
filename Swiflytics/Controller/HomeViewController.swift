//
//  HomeViewController.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 15/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController, StoryboardInstantiable, UITableViewDataSource, UITableViewDelegate {

    typealias ViewController = UINavigationController

    static let storyboardID = "HomeViewControllerID"

    var dataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swiflytics"
        dataSource.append("ok")
        dataSource.append("ok")
        dataSource.append("ok")
        dataSource.append("ok")
        dataSource.append("ok")
        dataSource.append("ok")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68.0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(HomeTableViewCell), forIndexPath: indexPath) as! HomeTableViewCell
        
        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
