//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Sarn Wattanasri on 2/29/16.
//  Copyright © 2016 Sarn. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var commentTextView: UITextView!
    var remaining: Int?
    var replyToUserScreenName: String?
    
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var remainingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.delegate = self
        tweetButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        
        if (replyToUserScreenName != nil){
            commentTextView.text = "@\(replyToUserScreenName!)"
            commentTextView.textColor = UIColor.blackColor()
        }
    }
    @IBAction func onTweet(sender: AnyObject) {
        // Post comment
        TwitterClient.sharedInstance.postTweet(commentTextView.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        remaining =  140 - commentTextView.text!.utf16.count
        remainingLabel.text = "\(remaining!)"
        
        // If no more character allows, textview will not accept anymore character
        // users can use backspace to delete the character
        if remaining == 0{
        commentTextView.deleteBackward()
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        commentTextView.text = nil
        commentTextView.textColor = UIColor.blackColor()
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
