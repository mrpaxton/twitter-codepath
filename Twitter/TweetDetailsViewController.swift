//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/28/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    @IBOutlet weak var userImageThubButton: UIButton!
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
    
    var tweet: Tweet!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = user.name
        handleLabel.text = "@\(user.screenName!)"
        if let url = tweet.mediaURL {
            userProfileImageView.setImageWithURL(url)
        }
        
        customizeFrame(userProfileImageView)
        
        messageLabel.text = tweet.text
        dateLabel.text = String(tweet.createdAt!)
        userURLLabel.text = user.userURL!
        
        retweetNumberLabel.text = "\(tweet.retweetCount!)"
        favouriteNumberLabel.text = "\(user.favouritesCount!)"
        
        
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
