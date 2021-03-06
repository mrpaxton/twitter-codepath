//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/6/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, TweetDetailsViewControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var userScreenName: String?
    
    var selectedTweet: Tweet!
    var selectedUser: User!
    
    
    var refreshControl: UIRefreshControl!
    
    
    //flag for infinite scroll
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var selectedCategories: [String]?
    
    var loadMoreOffset = 20
    
    //infinite scroll
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !isMoreDataLoading {
            //calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            //when the user has scrolled past the threshold, start requesting
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging {
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //load more data
                loadMoreData()
            }
        }
    }
    
    @available(iOS, deprecated=8.0) //suppress warning on deprecated GET from BDBOAuth1Manager's GET method
    func loadMoreData() {
        
        //call Twitter API to load the next set of data
        let twitterApiParams = [ "since_id": self.loadMoreOffset, "count": 20 ]
        TwitterClient.sharedInstance.homeTimelineWithParams(twitterApiParams) { tweets, error in
            
            if error != nil {
                self.delay(2.0, closure: {
                    self.loadingMoreView?.stopAnimating()
                    //TODO: show network error
                })
            } else {
                self.delay(0.5, closure: { Void in
                    self.loadMoreOffset += 20
                    self.tweets?.appendContentsOf(tweets!)
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false
                })
            }
            
        }
    }
    
    func setupInfiniteScrollView() {
        let frame = CGRectMake(0, tableView.contentSize.height,
            tableView.bounds.size.width,
            InfiniteScrollActivityView.defaultHeight
        )
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview( loadingMoreView! )
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    //pull to refresh
    func pullToRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    func delay(delay: Double, closure: () -> () ) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure
        )
    }
    
    
    @available(iOS, deprecated=8.0) //suppress warning on deprecated GET from BDBOAuth1Manager's GET method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        let twitterApiParams = [ "since_id": 20, "count": 20 ]
        TwitterClient.sharedInstance.homeTimelineWithParams(twitterApiParams) { tweets, error in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        pullToRefreshControl()
        setupInfiniteScrollView()
        
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "TwitterLogoBlueSmall"))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath)  as! TweetCell
            cell.tweet = tweets![indexPath.row]
            cell.delegate = self
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let detailsViewController = segue.destinationViewController as! TweetDetailsViewController
            detailsViewController.tweet = tweets![indexPath!.row]
            detailsViewController.user = tweets![indexPath!.row].user!
            detailsViewController.delegate = self
            
        }
        
        if segue.identifier == "replyFromHomeSegue" {
            let composeViewController = segue.destinationViewController as! ComposeViewController
            composeViewController.replyToUserScreenName = userScreenName
        }
        
        if segue.identifier == "profileSegue" {
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = self.selectedUser
            //profileViewController.tweet = selectedTweet
        }
    }
    
    func didReply(tweetCell: TweetCell) {
        print("Did Reply")
        // get the selected user screen name
        userScreenName = tweetCell.tweet.user?.screenName!
        performSegueWithIdentifier("replyFromHomeSegue", sender: self)
    }
    
    func didTapProfileThumb(tweetCell: TweetCell, selectedTweet: Tweet) {
        print("=========== in didTapProfileThumb()" )
        self.selectedTweet = selectedTweet
        self.selectedUser = tweetCell.tweet.user
        self.performSegueWithIdentifier("profileSegue", sender: self)
    }
    
    func didTapProfileThumbOnTweetDetailsPage(tweetDetailsViewController: TweetDetailsViewController, selectedTweet: Tweet) {
        print("=========== in didTapProfileThumbOnDetailsPage()" )
        self.selectedTweet = selectedTweet
        self.selectedUser = tweetDetailsViewController.tweet.user
        self.performSegueWithIdentifier("profileSegue", sender: self)
    }
    
}
