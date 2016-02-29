//
//  User.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/6/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import Foundation
import SwiftyJSON

var _currentUser: User?
let currentUserKey = "currentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    let id: Int?
    let idStr: String?
    var name: String?
    var screenName: String?
    var location: String?
    var userDescription: String?
    var userURL: String?
    var profileImageUrl: String?
    var profileBannerImageUrl: String?
    //var tagline: String?
    var statusesCount: Int?
    var friendsCount: Int?
    var followersCount: Int?
    var createdAt: NSDate?
    var favouritesCount: Int?
    var jsonData: JSON?
    
    init(jsonData: JSON) {
        self.jsonData = jsonData
        
        id = jsonData["id"].intValue
        idStr = jsonData["id_str"].stringValue
        name = jsonData["name"].stringValue
        screenName = jsonData["screen_name"].stringValue
        location = jsonData["location"].stringValue
        userDescription = jsonData["description"].stringValue
        userURL = jsonData["url"].stringValue
        profileImageUrl = jsonData["profile_image_url"].stringValue
        profileImageUrl = jsonData["profile_banner_url"].stringValue
        //tagline = jsonData["description"].stringValue
        statusesCount = jsonData["statuses_count"].intValue
        friendsCount = jsonData["friends_count"].intValue
        followersCount = jsonData["followers_count"].intValue
        createdAt = User.stringToNSDate( jsonData["created_at"].stringValue )
        favouritesCount = jsonData["favourites_count"].intValue
        
        
    }
    
    class func stringToNSDate(dateString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        let resultDate = dateFormatter.dateFromString(dateString)!
        dateFormatter.dateFormat = "eee MMM dd yyyy"
        
        return resultDate
    }
    
    func logout() {
        //Clear the current user
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        //Use NSNotification to broadcast so other part of app, interested when user logged out, knows
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    //Check if user logged in
    class var currentUser: User? {
        
        get {
            if _currentUser == nil {
                //logged out or just boot up
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if let data = data {
                    let dictionary: JSON?
                    do {
                        try dictionary = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? JSON
                        if let _ = dictionary {
                            _currentUser = User(jsonData: dictionary! )
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            return _currentUser
        }
       
        set(user) {
            _currentUser = user
            //User need to implement NSCoding; but, JSON also serialized by default
            if let _ = _currentUser {
                var data: NSData?
                do {
                    try data = NSJSONSerialization.dataWithJSONObject(user!.jsonData!.dictionaryObject!, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print(error)
                }
            } else {
                //Clear the currentUser data
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
        }
    }
}

