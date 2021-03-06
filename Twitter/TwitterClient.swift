//
//  TwitterClient.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/3/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import SwiftyJSON

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
    
    @available(iOS, deprecated=8.0) //suppress warning on deprecated GET from BDBOAuth1Manager's GET method
    func homeTimelineWithParams(params: NSDictionary? , completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json",
            parameters: params,
            success: { (operation: NSURLSessionDataTask?, response: AnyObject?) in
                //print("home timelines: \(response)")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                let tweetNames = tweets.map{ $0.text }
                print(tweetNames)
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) in
                print("error getting timeline")
                completion(tweets: nil, error: error)
            }
        )
    }    
    @available(iOS, deprecated=8.0)
    func postTweet(status: String) {
        let params = ["status": status]
        
        POST("1.1/statuses/update.json",
            parameters: params,
            success: {(operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("Posted status: \(status)")
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Failed to post status with text:\(status)")
        })
    }
    
    @available(iOS, deprecated=8.0)
    func favoriteStatus(tweetID: Int, completion: (error: NSError?) -> ()) {
        POST("/1.1/favorites/create.json", parameters: ["id": tweetID], success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, err: NSError!) -> Void in
                completion(error: err)
        })
    }
    
    @available(iOS, deprecated=8.0)
    func unfavoriteStatus(tweetID: Int, completion: (error: NSError?) -> ()) {
        POST("/1.1/favorites/destroy.json", parameters: ["id": tweetID], success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, err: NSError!) -> Void in
                completion(error: err)
        })
    }
    
    @available(iOS, deprecated=8.0)
    func retweetStatus(tweetID: Int, completion: (retweetedTweetID: Int?, error: NSError?) -> ()) {
        POST("/1.1/statuses/retweet/\(tweetID).json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //let tweetArray = Tweet.tweetsfromJSON(JSON(response))
            //completion(retweetedTweetID: tweetArray.first?.tweetID, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, err: NSError!) -> Void in
                completion(retweetedTweetID: nil, error: err)
        })
    }
    
    @available(iOS, deprecated=8.0)
    func unretweetStatus(retweetedTweetID: Int, completion: (error: NSError?) -> ()) {
        POST("/1.1/statuses/destroy/\(retweetedTweetID).json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, err: NSError!) -> Void in
                completion(error: err)
        })
    }
    
    func loginWithCompletion( completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //fetch request token and redirect to authorization page
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath( "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cptwitterdemo://oauth"),
            scope: nil,
            success: { (requestToken:BDBOAuth1Credential!) in
                //route to twitter api authorize page
                let authURL = NSURL(string:
                    "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)" )
                UIApplication.sharedApplication().openURL(authURL!)
                //route back to our page
            },
            failure: { (error: NSError!) in
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
            success: { (accessToken: BDBOAuth1Credential!)  in
                
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json",
                    parameters: nil,
                    success: { (operation: NSURLSessionDataTask, response: AnyObject?) in
                        let user = User(jsonData: JSON(response!) )
                        //currently logged in user
                        User.currentUser = user
                        print("Current user: \(User.currentUser?.name)")
                        
                        self.loginCompletion?(user: user, error: nil)
                    },
                    failure: { (operation: NSURLSessionDataTask?, error: NSError!) in
                        print("error getting current user")
                        self.loginCompletion?(user: nil, error: error)
                    }
                )
            },
            failure: { (error: NSError!)  in
                //print("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
}
