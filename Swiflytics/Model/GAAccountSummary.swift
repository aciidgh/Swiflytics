//
//  GAAccountSummary.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 15/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

struct GAAccountSummary {
    let id: String
    let name: String
    let views: [GAPropertyView]
    
    init(jsonDict: NSDictionary) {
        id = jsonDict["id"] as! String
        name = jsonDict["name"] as! String
        
        var views = [GAPropertyView]()
        
        for property in jsonDict["webProperties"] as! NSArray {
            views.appendContentsOf(GAPropertyView.summaryFromPropertyDict(property as! NSDictionary))
        }
        
        self.views = views
    }
    
    static func summaryFromArray(jsonArray: NSArray) -> [GAAccountSummary] {
        var array = [GAAccountSummary]()
        
        for json in jsonArray {
            array.append(GAAccountSummary(jsonDict: json as! NSDictionary))
        }
        
        return array
    }
}

enum GAPropertyViewType : String {
    case App = "APP"
    case Web = "WEB"
}

struct GAPropertyView {
    let propertyID: String
    let propertyName: String
    let viewName: String
    let viewID: String
    let viewType: GAPropertyViewType
    
    static func summaryFromPropertyDict(jsonObject: NSDictionary) -> [GAPropertyView] {
        
        let propertyID = jsonObject["id"] as! String
        let propertyName = jsonObject["name"] as! String
        
        var array = [GAPropertyView]()
        
        for viewDict in jsonObject["profiles"] as! NSArray {
            let view = GAPropertyView(propertyID: propertyID, propertyName: propertyName, viewName: viewDict["name"] as! String, viewID: viewDict["id"] as! String, viewType: GAPropertyViewType(rawValue: viewDict["type"] as! String)!)
            array.append(view)
        }
        return array
    }
}