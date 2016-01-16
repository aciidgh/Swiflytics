//
//  AnalyticsCard.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 16/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

let kRealtimeAnalyticsBaseURL = "https://www.googleapis.com/analytics/v3/data/realtime?"

enum AnalyticsMetric: String {
    case ActiveUsers = "rt:activeUsers"
    case Pageviews = "rt:pageviews"
}

enum AnalyticsDimension: String {
    case Country = "rt:country"
    case PagePath = "rt:pagePath"
    case PageTitle = "rt:pageTitle"
}

enum AnalyticsType {
    case Metric(AnalyticsMetric)
    case Dimension(AnalyticsDimension)
}

struct AnalyticsCard {
    
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
    
    func fetchData(viewID: String, clientID: String, accessToken: String, completion: (GAAnalytics?) -> ()) {
        
        let url = kRealtimeAnalyticsBaseURL + "ids=ga:\(viewID)"
                + "&metrics=\(metric.rawValue)"
                + "&dimensions=\(dimension.rawValue)"
                + "&key=\(clientID)"
                + "&access_token=\(accessToken)"
                + "&fields=columnHeaders/name,rows,totalResults,totalsForAllResults"
                + "&sort=-\(metric.rawValue)"
        
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
        let rows = json["rows"] as! NSArray
        
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
