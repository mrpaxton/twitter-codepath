//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/6/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    var tweets: [Tweet]?
    
    @available(iOS, deprecated=8.0) //suppress warning on deprecated GET from BDBOAuth1Manager's GET method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil , completion: { (tweets, error) -> () in
            self.tweets = tweets
            //can reload here too
        })
    }

    @IBAction func onLogout(sender: AnyObject) {
        if let user = User.currentUser {
            user.logout()
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
