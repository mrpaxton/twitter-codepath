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
    
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var statusesCount: Int?
    var friendsCount: Int?
    var followersCount: Int?
    var jsonData: JSON?
    
    init(jsonData: JSON) {
        self.jsonData = jsonData
        name = jsonData["name"].stringValue
        screenName = jsonData["screen_name"].stringValue
        profileImageUrl = jsonData["profile_image_url"].stringValue
        tagline = jsonData["description"].stringValue
        followersCount = jsonData["followers_count"].intValue
        friendsCount = jsonData["friends_count"].intValue
        statusesCount = jsonData["statuses_count"].intValue
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

