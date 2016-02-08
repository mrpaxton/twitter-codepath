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
    
    init(dictionary: NSDictionary) {
        
        user = User(jsonData: JSON( dictionary["user"]! ) )
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        return array.map{ Tweet(dictionary: $0) }
    }
}
