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
    
    var accountSummary = [GAAccountSummary]()

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
            return
        }
        
        fetchData {
            self.tableView.reloadData()
        }
      
    }

    func fetchData(completion: ()->()) {
    
        let clientID = GIDSignIn.sharedInstance().clientID
        
        let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
        
        let url = "https://www.googleapis.com/analytics/v3/management/accountSummaries?key=\(clientID)&access_token=\(accessToken)"
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            if let jsonObject = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)["items"] as! NSArray {
               self.accountSummary = GAAccountSummary.summaryFromArray(jsonObject)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion()
            })
            
        }.resume()
        
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
        return accountSummary[section].views.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(HomeTableViewCell), forIndexPath: indexPath) as! HomeTableViewCell
        
        let view = accountSummary[indexPath.section].views[indexPath.row]
        
        cell.mainTitle.text = view.propertyName
        cell.subTitle.text = view.viewName
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return accountSummary.count
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}