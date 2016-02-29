//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/21/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileThumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var numberTweets: UILabel!
    @IBOutlet weak var numberFollowings: UILabel!
    @IBOutlet weak var numberFollowers: UILabel!
    
    var user: User! {
        didSet {
            nameLabel.text = user.name
            handleLabel.text = user.screenName
            let headerURL = NSURL(string: user.profileImageUrl!)
            let thumbURL = NSURL(string: user.profileBannerImageUrl!)
            headerImageView.setImageWithURL(headerURL!)
            profileThumbImageView.setImageWithURL(thumbURL!)
            locationLabel.text = user.location
            userDescriptionLabel.text = user.description
            numberTweets.text = String(user.statusesCount)
            numberFollowings.text = String(user.friendsCount)
            numberFollowers.text = String(user.followersCount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = User.currentUser {
            nameLabel.text = user.name
            handleLabel.text = user.screenName
            let headerURL = NSURL(string: user.profileImageUrl!)
            let thumbURL = NSURL(string: user.profileBannerImageUrl!)
            headerImageView.setImageWithURL(headerURL!)
            profileThumbImageView.setImageWithURL(thumbURL!)
            locationLabel.text = user.location
            userDescriptionLabel.text = user.description
            numberTweets.text = String(user.statusesCount)
            numberFollowings.text = String(user.friendsCount)
            numberFollowers.text = String(user.followersCount)
            
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
