//
//  User.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/6/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import Foundation

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
    
    //check if user logged in
    /*class var currentUser: User? {
        
        get {
        if _currentUser == nil {
        //logged out or just boot up
        var data = NSUserDefaults.standardUserDefaults.objectForKey(currentUserKey)
        if data != nil {
        var dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil)
        _currentUser = User(dictionary: dictionary)
        ...
        }
        }
        return _currentUser
        
        }
        set(user) {
            _currentUser = user
            
            //User need to implement NSCoding
            //JSON also serialized by default
            //cheat a bit here
            
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user?dictionary, options: nil, error: nil) {
                    NSUserDefaults.standardUserDefaults.setObject(data, forKey: currentUser)
                    else {
                        
                        NSUserDefaults.standardUserDefaults.setObject(nil, forKey: currentUser)
                        NSUserDefaults.standardUserDefaults.synchonize
                    }
                }
            }
    */
            
}

