//
//  TweetViewController.swift
//  Twitter
//
//  Created by Will Gilman on 4/13/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    @IBOutlet var tweetDetailView: TweetView!
    
    var tweet: Tweet?
    var retweeted: Bool! = false
    var retweetCount: Int! = 0
    var favorited: Bool! = false
    var favoriteCount: Int! = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        tweetDetailView.tweet = tweet
        
        // Configure navigation bar.
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(red: 62.0 / 255.0, green: 204.0 / 255.0, blue: 1.0, alpha: 1.0)
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor.white
            ]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retweetButtonTapped(_ sender: UIButton) {
        if !retweeted && tweet?.retweetCount != nil {
            TwitterClient.sharedInstance?.retweet(id: (tweet?.id)!, success: { (tweet: Tweet) in
                print("Retweeted: \(tweet.text!)")
                self.tweetDetailView.retweetButton.alpha = 1.0
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
            retweetCount = tweet?.retweetCount
            retweetCount = retweetCount! + 1
            tweet?.retweetCount = retweetCount!
            tweetDetailView.tweet = tweet
            retweeted = true
        } else if retweeted && retweetCount != 0 {
            retweetCount = tweet?.retweetCount
            retweetCount = retweetCount! - 1
            tweet?.retweetCount = retweetCount!
            tweetDetailView.tweet = tweet
            retweeted = false
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if !favorited && tweet?.favoritesCount != nil {
            TwitterClient.sharedInstance?.favorite(id: (tweet?.id)!, action: nil, success: { (resp: NSDictionary) in
                print("Favorited: \(resp["text"]!)")
                self.tweetDetailView.favoriteButton.alpha = 1.0
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
            favoriteCount = tweet?.favoritesCount
            favoriteCount = favoriteCount! + 1
            tweet?.favoritesCount = favoriteCount!
            tweetDetailView.tweet = tweet
            favorited = true
        } else if favorited && favoriteCount != 0 {
            TwitterClient.sharedInstance?.unfavorite(id: (tweet?.id)!, action: nil, success: { (resp:NSDictionary) in
                print("Unfavorited: \(resp["text"]!)")
                self.tweetDetailView.favoriteButton.alpha = 0.4
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
            favoriteCount = tweet?.favoritesCount
            favoriteCount = favoriteCount! - 1
            tweet?.favoritesCount = favoriteCount!
            tweetDetailView.tweet = tweet
            favorited = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replyFromViewSegue" || segue.identifier == "replyFromNavItemSegue" {
            let navigationController = segue.destination as! UINavigationController
            let newTweetViewController = navigationController.topViewController as! NewTweetViewController
            newTweetViewController.replyToUserScreenName = tweet?.user?.screenname
            newTweetViewController.reply_id = tweet?.id
        }
    }
    

}
