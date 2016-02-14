//
//  TweetCell.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/11/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favouriteCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            let url = NSURL( string: ( tweet.user?.profileImageUrl!)! )
            print(url!)
            profileImage.setImageWithURL(url!)//, placeholderImage: UIImage(named: "TwitterLogoBlue")!)
            screenNameLabel.text = "@\((tweet.user?.screenName)!)"
            nameLabel.text = tweet.user?.name
            tweetTextLabel.text = tweet.text
            retweetCountLabel.text = String(tweet.retweetCount)
            favouriteCountLabel.text = String(tweet.favouriteCount)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onReply(sender: AnyObject) {
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
    }
    
    
    @IBAction func onlikePressed(sender: AnyObject) {
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
