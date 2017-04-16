//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Will Gilman on 4/12/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewTweetViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure refresh control.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        // Configure table view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.insertSubview(refreshControl, at: 0)
        
        // Set delegate for new tweet view.
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let nc = storyboard.instantiateViewController(withIdentifier: "NewTweetNavigationController") as! UINavigationController
//        let vc = nc.topViewController as! NewTweetViewController
//        vc.delegate = self
        
        // Configure navigation bar.
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(red: 62.0 / 255.0, green: 204.0 / 255.0, blue: 1.0, alpha: 1.0)
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor.white
            ]
        }

        makeTwitterRequest()
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    // Delegate methods.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func didTweet(newTweetViewController: NewTweetViewController, tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
    
    // Segue method.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTweetSegue" {
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
        
            let tweetViewController = segue.destination as! TweetViewController
            tweetViewController.tweet = tweet
            
        } else if segue.identifier == "newTweetSegue" {
            
            let navigationController = segue.destination as! UINavigationController
            let newTweetViewController = navigationController.topViewController as! NewTweetViewController
            newTweetViewController.replyToUserScreenName = nil
            newTweetViewController.reply_id = nil
            newTweetViewController.delegate = self
        }
    }
    
    // Helper functions.
    func makeTwitterRequest() {
        TwitterClient.sharedInstance?.homeTimeline(sucess: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        makeTwitterRequest()
        refreshControl.endRefreshing()
    }

}
