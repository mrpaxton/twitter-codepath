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
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret
            )
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary? , completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json",
            parameters: params,
            success: { (operation: NSURLSessionDataTask?, response: AnyObject?) -> Void in
                //print("home timelines: \(response)")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting timeline")
                completion(tweets: nil, error: error)
            }
        )
    }
    
    func loginWithCompletion( completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //fetch request token and redirect to authorization page
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath( "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cptwitterdemo://oauth"),
            scope: nil,
            success: { (requestToken:BDBOAuth1Credential!) -> Void in
                //route to twitter api authorize page
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)" )
                UIApplication.sharedApplication().openURL(authURL!)
                //route back to our page
            },
            failure: { (error: NSError!) -> Void in
                print("Falied to get request token")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
    
    @available(iOS, deprecated=8.0) //suppress warning on deprecated GET from BDBOAuth1Manager's GET method
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json",
                    parameters: nil,
                    success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                        //print("user: \(response)")
                        //create a User
                        let user = User(dictionary: response as! NSDictionary)
                        //currently logged in user
                        User.currentUser = user
                        print("Current user: \(User.currentUser?.name)")
                        
                        self.loginCompletion?(user: user, error: nil)                    },
                    failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                        print("error getting current user")
                        self.loginCompletion?(user: nil, error: error)
                    }
                )
                
                
            },
            failure: { (error: NSError!) -> Void in
                //print("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
}
