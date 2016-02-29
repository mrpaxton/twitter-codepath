//
//  Tweet.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/6/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import Foundation
import SwiftyJSON

class Tweet: NSObject {
    
    var user: User?
    var id: Int?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favouriteCount: Int?
    var retweetCount: Int?
    var favourited: Bool?
    var retweeted: Bool?
    
    
    var mediaURL: NSURL?
    
    init(jsonData: JSON) {
        
        user = User(jsonData: jsonData["user"]  )
        
        id = jsonData["id"].intValue
        text = jsonData["text"].stringValue
        createdAtString = jsonData["created_at"].stringValue
        favouriteCount = jsonData["favourite_count"].intValue
        retweetCount = jsonData["retweet_count"].intValue
        favourited = jsonData["favourited"].boolValue
        retweeted = jsonData["retweeted"].boolValue
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
       
        let urlString = jsonData["entities"]["media"][0]["media_url"].stringValue
        mediaURL = NSURL(string: urlString)
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        //array.forEach{ print($0.text) }
        return array.map{ Tweet(jsonData: JSON($0)) }
    }
}
