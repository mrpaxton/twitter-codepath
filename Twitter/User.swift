//
//  User.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/6/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import Foundation

var _currentUser: User?
let currentUserKey = "currentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
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
                if data != nil {
                    let dictionary: NSDictionary?
                    do {
                        try dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        _currentUser = User(dictionary: dictionary!)
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
                    try data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: .PrettyPrinted)
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

