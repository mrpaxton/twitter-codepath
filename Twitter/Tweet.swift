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
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favouriteCount: Int?
    var retweetCount: Int?
    var isFavourite: Bool?
    var isRetweeted: Bool?
    
    
//    init(dictionary: NSDictionary) {
//        
//        user = User(jsonData: JSON( dictionary["user"]! ) )
//        text = dictionary["text"] as? String
//        createdAtString = dictionary["created_at"] as? String
//        
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
//        createdAt = formatter.dateFromString(createdAtString!)
//    }
    
    init(jsonData: JSON) {
        
        user = User(jsonData: jsonData["user"]  )
        text = jsonData["text"].stringValue
        createdAtString = jsonData["created_at"].stringValue
        favouriteCount = jsonData["favourite_count"].intValue
        retweetCount = jsonData["retweet_count"].intValue
        isFavourite = jsonData["favourited"].boolValue
        isRetweeted = jsonData["retweeted"].boolValue
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)

    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        return array.map{ Tweet(jsonData: JSON($0)) }
    }
}
