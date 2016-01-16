//
//  CardManager.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 16/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

let kCardsPersistanceKey = "CardsPersistanceKey"

class CardManager {
    
    static let sharedManager = CardManager()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    private var cards = [AnalyticsCard]()
    
    private init() {
        
        let savedCards = userDefaults.objectForKey(kCardsPersistanceKey)
        
        if case let savedCardsArray as NSArray = savedCards {
            for case let savedCard as NSDictionary in savedCardsArray  {
                guard let card = AnalyticsCard.from(savedCard) else { continue }
                cards.append(card)
            }
        }
        
        cards = cards.count == 0 ? AnalyticsCard.defaultCards() : cards
    }
    
    func allCards() -> [AnalyticsCard] {
        return cards
    }
    
    func addCard(card: AnalyticsCard) {
        if let _ = cards.indexOf(card) {
            return
        }
        cards.append(card)
        saveCards()
    }
    
    func removeCard(card: AnalyticsCard) {
        if let index = cards.indexOf(card) {
            cards.removeAtIndex(index)
        }
        saveCards()
    }
    
    private func saveCards() {
        let array = cards.map { $0.toDict() } as NSArray
        userDefaults.setObject(array, forKey: kCardsPersistanceKey)
        userDefaults.synchronize()
    }
}
