//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/28/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit


protocol TweetDetailsViewControllerDelegate {
    func didTapProfileThumbOnTweetDetailsPage(tweetDetailsViewController: TweetDetailsViewController, selectedTweet: Tweet)
}

class TweetDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var profileThumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userURLLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!

    @IBOutlet weak var retweetNumberLabel: UILabel!
    @IBOutlet weak var favouriteNumberLabel: UILabel!
    
    var delegate: TweetDetailsViewControllerDelegate!
    
    var tweet: Tweet!
    var user: User!
    
    var tweetId: Int!
    
    var didRetweet = false
    var didTouchFavourite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = user.name
        handleLabel.text = "@\(user.screenName!)"
        if let url = tweet.mediaURL {
            userProfileImageView.setImageWithURL(url)
        }
        
        if let urlString = tweet.user?.profileImageUrl {
            profileThumbImageView.setImageWithURL(NSURL(string: urlString )!)
        }
        
        customizeFrame(userProfileImageView)
        
        messageLabel.text = tweet.text
        dateLabel.text = String(tweet.createdAt!)
        userURLLabel.text = user.userURL!
        
        retweetNumberLabel.text = "\(tweet.retweetCount!)"
        favouriteNumberLabel.text = "\(user.favouritesCount!)"
        
        
        //add a tap gesture recognizer to the profile image view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("onImageTapped:"))
        profileThumbImageView.addGestureRecognizer(tapGestureRecognizer)
        profileThumbImageView.userInteractionEnabled = true
        
        tweetId = tweet.id

        
        
    }
    
    func onImageTapped(sender: UIGestureRecognizer) {
        self.delegate?.didTapProfileThumbOnTweetDetailsPage(self, selectedTweet: tweet)
    }

    
    @IBAction func onReply(sender: AnyObject) {
        print("onReply clicked")
        //self.delegate?.didReply(self)
        //TODO: create a reply feature
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if !didRetweet {
            //perform retweet logics
            TwitterClient.sharedInstance.retweetStatus(tweetId) { error in
                self.tweet.retweetCount! += 1
                self.retweetButton.setImage(UIImage(named: "RetweetIconOn"), forState: .Normal)
                self.retweetNumberLabel.text = "\(self.tweet.retweetCount!)"
                self.didRetweet = true
            }
        } else {
            //un retweet, if successful, decrement
            TwitterClient.sharedInstance.unretweetStatus(tweetId) { error in
                
            }
        }
    }
    
    @IBAction func onFavourite(sender: AnyObject) {
        if !didTouchFavourite {
            //call favourite
            TwitterClient.sharedInstance.favoriteStatus(tweetId) { errror in
                //toggle button
                self.didTouchFavourite = true
                //increment count
                self.tweet.favouriteCount! += 1
                //swap button image
                self.favouriteButton.setImage(UIImage(named: "LikeIconOn"), forState: .Normal)
                //reset favouriteCount
                self.tweet.favouriteCount = self.tweet.favouriteCount < 0 ? 0 : self.tweet.favouriteCount
                //update favourite count label
                self.favouriteNumberLabel.text = "\(self.tweet.favouriteCount!)"            }
        } else {
            //call unfavouriteStatus
            TwitterClient.sharedInstance.unfavoriteStatus(tweetId) { error in
                self.didTouchFavourite = false
                self.tweet.favouriteCount! -= 1
                self.favouriteButton.setImage(UIImage(named: "LikeIcon"), forState: .Normal)
                self.tweet.favouriteCount = self.tweet.favouriteCount < 0 ? 0 : self.tweet.favouriteCount
                self.favouriteNumberLabel.text = "\(self.tweet.favouriteCount!)"
            }
        }

    }
    
    func customizeFrame(userProfileImageView: UIImageView) {
        userProfileImageView.layer.cornerRadius = 8
        userProfileImageView.layer.borderWidth = 3
        userProfileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        userProfileImageView.clipsToBounds = true
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
