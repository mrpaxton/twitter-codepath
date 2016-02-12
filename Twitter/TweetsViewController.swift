//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/6/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    
    @available(iOS, deprecated=8.0) //suppress warning on deprecated GET from BDBOAuth1Manager's GET method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { tweets, error in
            
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath)  as! TweetCell
        let tweet = tweets![indexPath.row]
        cell.screenNameLabel.text = tweet.user?.screenName
        cell.nameLabel.text = tweet.user?.name
        cell.textLabel!.text = tweet.text
        cell.retweetCountLabel.text = String(tweet.retweetCount)
        cell.favouriteCountLabel.text = String(tweet.favouriteCount)
        
        return cell
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
