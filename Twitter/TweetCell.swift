//
//  TweetCell.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/11/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit
import SwiftMoment

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favouriteCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var didRetweet = false
    var didTouchFavourite = false
    
    var tweetId: Int!
    
    var tweet: Tweet! {
        didSet {
            tweetId = tweet.id
            let url = NSURL( string: ( tweet.user?.profileImageUrl!)! )
            print(url!)
            profileImage.setImageWithURL(url!)//, placeholderImage: UIImage(named: "TwitterLogoBlue")!)
            screenNameLabel.text = "@\((tweet.user?.screenName)!)"
            nameLabel.text = tweet.user?.name
            tweetTextLabel.text = tweet.text
            retweetCountLabel.text = String(tweet.retweetCount!)
            favouriteCountLabel.text = String(tweet.favouriteCount!)
            timeAgoLabel.text = durationString(tweet.createdAt!)
        }
    }

    @IBAction func onReply(sender: AnyObject) {
        print("onReply clicked")
        //TODO: create a reply feature
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if !didRetweet {
            //perform retweet logics
            
            //increment the retweet count
            self.tweet.retweetCount! += 1
        } else {
            //un retweet, if successful, decrement
            
        }
        
        //update text label
        retweetCountLabel.text = "\(tweet.retweetCount!)"
        
    }
    
    func durationString(createdAt: NSDate?) -> String {
        let durationAgo = (moment() - moment(createdAt!))
        if durationAgo.hours >= 24 {
            return "\(Int(durationAgo.days))d"
        } else if durationAgo.minutes >= 60 {
            return "\(Int(durationAgo.hours))h"
        } else if durationAgo.seconds >= 60 {
            return "\(Int(durationAgo.minutes))m"
        } else {
            return "1m"
        }
    }
    
    @IBAction func onFavourite(sender: AnyObject) {
        if !didTouchFavourite {
            didTouchFavourite = true
            self.tweet.favouriteCount! += 1
            //change color of the button to red
            favouriteButton.setImage(UIImage(named: "LikeIconOn"), forState: .Normal)
            
        } else {
            //unFavourite
            TwitterClient.sharedInstance.unfavoriteStatus(tweetId) { error in
                //update favouriteCount
                
            }
            didTouchFavourite = false
            self.tweet.favouriteCount! -= 1
            //change color of the button to gray
            favouriteButton.setImage(UIImage(named: "LikeIcon"), forState: .Normal)
        }
        favouriteCountLabel.text = "\(tweet.favouriteCount!)"
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //set tweetId
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
