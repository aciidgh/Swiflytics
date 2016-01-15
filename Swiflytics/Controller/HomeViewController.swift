//
//  HomeViewController.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 15/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController, StoryboardInstantiable {

    typealias ViewController = UINavigationController

    static let storyboardID = "HomeViewControllerID"

    @IBOutlet var tableView: UITableView!
    
    var dataSource = [String: [String]]()
    let headers = ["one", "two", "three"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swiflytics"
        
        let headers = ["one", "two", "three"]
        
        for header in headers {
            dataSource[header] = ["one", "two", "three"]
        }
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func logoutPressed() {
        GIDSignIn.sharedInstance().signOut()
        UIView.transitionWithView(self.view.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            self.view.window?.rootViewController = LoginViewController.instance(self.storyboard!)
            }, completion: nil)
    }
    
    @IBAction func refreshPressed() {
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[headers[section]]!.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(HomeTableViewCell), forIndexPath: indexPath) as! HomeTableViewCell
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}