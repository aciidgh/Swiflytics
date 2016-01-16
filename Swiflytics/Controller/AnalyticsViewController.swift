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
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cards = CardManager.sharedManager.allCards()
        collectionView.reloadData()
    }
}

extension AnalyticsViewController: AnalyticsCardDelegate {
    func didRemoveCard() {
        refreshPressed(nil)
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
        
        card.fetchData(profile.profileID, clientID: clientID, accessToken: accessToken) { gaAnalytics in
            if card == cell.card {
                cell.gaAnalytics = gaAnalytics
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
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 77)
    }
}

extension AnalyticsViewController: UICollectionViewDelegate {
    
}