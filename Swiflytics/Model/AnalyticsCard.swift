//
//  AnalyticsCard.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 16/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit
import Mapper

let kRealtimeAnalyticsBaseURL = "https://www.googleapis.com/analytics/v3/data/realtime?"

protocol EnumCollectable {
    var stringValue: String { get }
    static func allValues() -> [Self]
}

enum AnalyticsMetric: String, EnumCollectable {
    case ActiveUsers = "rt:activeUsers"
    case Pageviews = "rt:pageviews"
    
     static func allValues() -> [AnalyticsMetric] {
        return [.ActiveUsers, .Pageviews]
    }
    
    var stringValue: String {
        return self.rawValue
    }
}

enum AnalyticsDimension: String, EnumCollectable {
    case Country = "rt:country"
    case PagePath = "rt:pagePath"
    case PageTitle = "rt:pageTitle"
    
    static func allValues() -> [AnalyticsDimension] {
        return [.Country, .PagePath, .PageTitle]
    }
    
    var stringValue: String {
        return self.rawValue
    }
}

func ==(lhs: AnalyticsCard, rhs: AnalyticsCard) -> Bool {
    return (lhs.cardName == rhs.cardName
        && lhs.dimension == rhs.dimension
        && lhs.metric == rhs.metric)
}

struct AnalyticsCard: Equatable, Mappable {
    
    let cardName: String
    let dimension: AnalyticsDimension
    let metric: AnalyticsMetric
    
    static func defaultCards() -> [AnalyticsCard] {
        var cards = [AnalyticsCard]()
        
        var card = AnalyticsCard(cardName: "Active Pages", dimension: .PageTitle, metric: .ActiveUsers)
        cards.append(card)
        
        card = AnalyticsCard(cardName: "Geo", dimension: .Country, metric: .ActiveUsers)
        cards.append(card)
        
        return cards
    }
    
    init(cardName: String, dimension: AnalyticsDimension, metric: AnalyticsMetric) {
        self.cardName = cardName
        self.dimension = dimension
        self.metric = metric
    }
    
    init(map: Mapper) throws {
        try cardName = map.from("cardName")
        try dimension = map.from("dimension")
        try metric = map.from("metric")
    }
    
    func toDict() -> NSDictionary {
        return ["cardName": cardName, "dimension": dimension.rawValue, "metric": metric.rawValue]
    }
    
    func fetchData(viewID: String, clientID: String, accessToken: String, completion: (GAAnalytics?) -> ()) {
        
        let url = kRealtimeAnalyticsBaseURL + "ids=ga:\(viewID)"
                + "&metrics=\(metric.rawValue)"
                + "&dimensions=\(dimension.rawValue)"
                + "&key=\(clientID)"
                + "&access_token=\(accessToken)"
                + "&fields=columnHeaders/name,rows,totalResults,totalsForAllResults"
                + "&sort=-\(metric.rawValue)"
                + "&max-results=10"
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) -> Void in
            
            guard let data = data else { return }
            
            var gaAnalytics: GAAnalytics? = nil
            
            if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary, let jsonUnWrapped = json {
                
                gaAnalytics = self.parseJSON(jsonUnWrapped)
                
            }
            
            onMainThread { completion(gaAnalytics) }
            
        }.resume()
    }
    
    /// Shit but works for now
    func parseJSON(json: NSDictionary) -> GAAnalytics {
        
        var tuple: (AnalyticsDimension, AnalyticsMetric, [String], [String]) = (.Country, .Pageviews, [String](), [String]())
        
        let columns = json["columnHeaders"] as! NSArray
        
        let count = (json["totalResults"] as! NSNumber).integerValue
        
        let rows = count > 0 ? json["rows"] as! NSArray : [AnyObject]()
        
        for case let column as NSDictionary in columns {
            let columnName = column["name"] as! String
            
            let indexOfType = columns.indexOfObject(column)
            
            if let metric = AnalyticsMetric(rawValue: columnName) {
                tuple.1 = metric
                for case let value as NSArray in rows {
                    tuple.3.append((value[indexOfType] as! String))
                }
            }

            if let dimension = AnalyticsDimension(rawValue: columnName) {
                tuple.0 = dimension
                for case let value as NSArray in rows {
                    tuple.2.append(value[indexOfType] as! String)
                }
            }
        }
        
        return GAAnalytics(dimension: tuple.0, metric: tuple.1, dimensionValues: tuple.2, metricValues: tuple.3)
    }
}

extension String {

    var urlEncoded: String {
        let characters = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        characters.removeCharactersInString("&")
        guard let encodedString = self.stringByAddingPercentEncodingWithAllowedCharacters(characters) else {
            return self
        }
        return encodedString
    }
}
