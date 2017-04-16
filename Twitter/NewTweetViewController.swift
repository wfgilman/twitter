//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Will Gilman on 4/14/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    
    @objc optional func didTweet(newTweetViewController: NewTweetViewController, tweet: Tweet)
}

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var newTweetView: NewTweetView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var user: User!
    var replyToUserScreenName: String?
    var reply_id: String?
    
    weak var delegate: NewTweetViewControllerDelegate?
    
    let remainingCharacters = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
    let tweetButton = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(tweetButtonTapped(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = User.currentUser
        newTweetView.user = user
        
        tweetTextView.delegate = self
        
        // Recieve reply and put screenname into UITextView.
        if replyToUserScreenName != nil {
            tweetTextView.text = "@\(replyToUserScreenName!) "
        }
        
        // Configure navigation bar.
        let chars = getRemainingCharacters(textView: tweetTextView)
        remainingCharacters.text = "\(chars)"
        remainingCharacters.textAlignment = NSTextAlignment.left
        remainingCharacters.textColor = UIColor.white
        let remainingCharsButton = UIBarButtonItem(customView: remainingCharacters)
        navigationItem.rightBarButtonItems = [tweetButton, remainingCharsButton]
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(red: 62.0 / 255.0, green: 204.0 / 255.0, blue: 1.0, alpha: 1.0)
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor.white
            ]
        }
        
        tweetTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tweetTextView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let chars = getRemainingCharacters(textView: textView)
        remainingCharacters.text = "\(chars)"
        let remainingCharsButton = UIBarButtonItem(customView: remainingCharacters)
        navigationItem.setRightBarButtonItems([tweetButton, remainingCharsButton], animated: false)
    }
    
    func getRemainingCharacters(textView: UITextView) -> Int {
        if textView.text != nil {
            return 140 - textView.text!.characters.count
        } else {
            return 140
        }
    }
    
    func tweetButtonTapped(_ sender: UIBarButtonItem) {
        if let tweetText = tweetTextView.text {
            if reply_id != nil {
                TwitterClient.sharedInstance?.reply(status: tweetText, reply_id: reply_id, success: { (tweet: Tweet) in
                    print("Replied: \(tweet.text!)")
                    self.delegate?.didTweet?(newTweetViewController: self, tweet: tweet)
                }, failure: { (error: Error) in
                    print("Error: \(error.localizedDescription)")
                })
            } else {
                TwitterClient.sharedInstance?.tweet(status: tweetText, success: { (tweet: Tweet) in
                    print("Tweeted: \(tweet.text!)")
                    self.delegate?.didTweet?(newTweetViewController: self, tweet: tweet)
                }, failure: { (error: Error) in
                    print("Error: \(error.localizedDescription)")
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
