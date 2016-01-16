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
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cards = AnalyticsCard.defaultCards()
        collectionView.reloadData()
    }
}

extension AnalyticsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(AnalyticsCardCollectionViewCell), forIndexPath: indexPath) as! AnalyticsCardCollectionViewCell
        
        let card = cards[indexPath.row]
        cell.cardTitle.text = card.cardName
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension AnalyticsViewController:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = UIScreen.mainScreen().bounds.size.width - 16
        
        return CGSizeMake(width, 154)
    }
}

extension AnalyticsViewController: UICollectionViewDelegate {
    
}