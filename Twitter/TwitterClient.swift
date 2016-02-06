//
//  TwitterClient.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/3/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "uFyblsq7DvCm7ZeaxGyDKtkE0"
let twitterConsumerSecret = "YIK7em8WNQwGvk7SP5sf3EhtVw8iARaGL7C73avf5pCB2Owyfp"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret
            )
        }
        return Static.instance
    }

}
