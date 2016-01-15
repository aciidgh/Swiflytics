//
//  GAAccountSummary.swift
//  Swiflytics
//
//  Created by Ankit Aggarwal on 15/01/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit
import Mapper

struct GAAccountSummary: Mappable {
    let id: String
    let name: String
    let properties: [GAProperty]
    
    var allProfiles: [GAPropertyProfile] {
        var profiles = [GAPropertyProfile]()
        
        for property in self.properties {
            for profile in property.profiles {
                let propertyProfile = GAPropertyProfile(propertyID: property.id, propertyName: property.name, profileID: profile.id, profileName: profile.name, profileType: profile.type)
                profiles.append(propertyProfile)
            }
        }
        return profiles
    }
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
        try properties = map.from("webProperties")
    }
    
    static func fetchSummary(clientID: String, accessToken: String, completion: ([GAAccountSummary]) -> () ) {
        let url = "https://www.googleapis.com/analytics/v3/management/accountSummaries?key=\(clientID)&access_token=\(accessToken)"
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) -> Void in
            guard let data = data else { return }
            
            var result = [GAAccountSummary]()
            
            if let json = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)["items"] as? NSArray, let jsonUnWrapped = json {
                
                for case let jsonObject as NSDictionary in jsonUnWrapped {
                    guard let summary = GAAccountSummary.from(jsonObject) else { continue }
                    result.append(summary)
                }
            }
            
            onMainThread {
                completion(result)
            }
        }.resume()
    }
}

enum GAProfileSummaryType: String {
    case App = "APP"
    case Web = "WEB"
}

struct GAPropertyProfile {
    let propertyID: String
    let propertyName: String
    let profileID: String
    let profileName: String
    let profileType: GAProfileSummaryType
}

struct GAProfileSummary: Mappable {
    let id: String
    let name: String
    let type: GAProfileSummaryType
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
        try type = map.from("type")
    }
}

struct GAProperty: Mappable {
    let id: String
    let name: String
    let profiles: [GAProfileSummary]
   
    init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
        try profiles = map.from("profiles")
    }
}