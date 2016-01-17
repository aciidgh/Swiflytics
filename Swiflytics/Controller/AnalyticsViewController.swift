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
    var cards = [AnalyticsCard]()
    let clientID = GIDSignIn.sharedInstance().clientID
    let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
    
    var gaAnalytics = [Int: GAAnalytics]()
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activeUsersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Real Time"
        
        cards = CardManager.sharedManager.allCards()
        collectionView.reloadData()
        
        let refreshBtn = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.Plain, target: self, action: "refreshPressed:")
        self.navigationItem.rightBarButtonItem = refreshBtn
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshPressed(nil)
    }
    
    @IBAction func addCardPressed(sender: AnyObject?) {
        let vc = AddCardViewController.instance(self.storyboard!)!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refreshPressed(sender: AnyObject?) {
        gaAnalytics = [Int: GAAnalytics]()
        cards = CardManager.sharedManager.allCards()
        collectionView.reloadData()
        
        fetchTotalOnlineUsers {
            self.activeUsersLabel.text = $0
        }
    }
    
    func fetchTotalOnlineUsers(completion: (String)->()) {
        
        let url = kRealtimeAnalyticsBaseURL + "ids=ga:\(profile.profileID)"
            + "&metrics=\(AnalyticsMetric.ActiveUsers.rawValue)"
            + "&key=\(clientID)"
            + "&access_token=\(accessToken)"
            + "&fields=totalsForAllResults"
        
        var onlineUsers = "0"
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) -> Void in
            
            guard let data = data else { return }
            
            if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary,
                let jsonUnWrapped = json,
                let totalResults = jsonUnWrapped["totalsForAllResults"] as? NSDictionary {
                
                onlineUsers = (totalResults[AnalyticsMetric.ActiveUsers.rawValue] as! String)
            }
            onMainThread { completion(onlineUsers) }
        }.resume()
    }
}

extension AnalyticsViewController: AnalyticsCardDelegate {
    func didPressRemoveCard(card: AnalyticsCard) {
        
        let alert = UIAlertController(title: "Remove Card", message: "Are you sure?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Yes", style: .Destructive) { (action) in
            CardManager.sharedManager.removeCard(card)
            self.refreshPressed(nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension AnalyticsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(AnalyticsCardCollectionViewCell), forIndexPath: indexPath) as! AnalyticsCardCollectionViewCell
        
        let card = cards[indexPath.row]
        cell.card = card
        cell.delegate = self
        cell.cardTitle.text = card.cardName
        cell.layoutIfNeeded()
        
        cell.gaAnalytics = gaAnalytics[indexPath.row]
        
        if gaAnalytics[indexPath.row] == nil {
            card.fetchData(profile.profileID, clientID: clientID, accessToken: accessToken) { gaAnalytics in
                if card == cell.card {
                    self.gaAnalytics[indexPath.row] = gaAnalytics
                    cell.gaAnalytics = gaAnalytics
                }
            }
        }
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "AnalyticsFooter", forIndexPath: indexPath)
        return view
    }
}

extension AnalyticsViewController:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = UIScreen.mainScreen().bounds.size.width - 16
        
        return CGSizeMake(width, 154)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 77 + 16)
    }
}

extension AnalyticsViewController: UICollectionViewDelegate {
    
}