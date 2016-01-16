//
//  HomeViewController.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 15/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, StoryboardInstantiable {

    typealias ViewController = UINavigationController
    static let storyboardID = "HomeViewControllerID"
    
    @IBOutlet var tableView: UITableView!
    
    var accountSummary = [GAAccountSummary]()
    var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Swiflytics"
    
        tableView.tableFooterView = UIView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveToggleAuthUINotification:", name: kGoogleSigninAuthToggled, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kGoogleSigninAuthToggled, object: nil)
    }

    @objc func receiveToggleAuthUINotification(notification: NSNotification) {
        guard notification.name == kGoogleSigninAuthToggled else {
            return
        }
        
        guard let _ = GIDSignIn.sharedInstance().currentUser else {
            print("Auth failed")
            logoutPressed()
            return
        }
        
        loggedIn = true
        
        fetchData {
            self.tableView.reloadData()
        } 
    }

    func fetchData(completion: ()->()) {
        
        guard loggedIn else {
            showAlertWithText("Please wait while we're authenticating", onViewController: self);
            return
        }
        
        let clientID = GIDSignIn.sharedInstance().clientID
        let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
        GAAccountSummary.fetchSummary(clientID, accessToken: accessToken) {
            self.accountSummary = $0
            completion()
        }
    }
    
    @IBAction func logoutPressed() {
        GIDSignIn.sharedInstance().signOut()
        UIView.transitionWithView(self.view.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: { () -> Void in
            self.view.window?.rootViewController = LoginViewController.instance(self.storyboard!)
            }, completion: nil)
    }
    
    @IBAction func refreshPressed() {
        fetchData {
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return accountSummary[section].name
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSummary[section].allProfiles.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(HomeTableViewCell), forIndexPath: indexPath) as! HomeTableViewCell
        
        let profile = accountSummary[indexPath.section].allProfiles[indexPath.row]
        
        cell.mainTitle.text = profile.propertyName
        cell.subTitle.text = profile.profileName
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return accountSummary.count
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let profile = accountSummary[indexPath.section].allProfiles[indexPath.row]
        let analyticsVC = AnalyticsViewController.instance(storyboard!)!
        analyticsVC.profile = profile
        navigationController?.pushViewController(analyticsVC, animated: true)
    }
}