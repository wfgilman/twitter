//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Will Gilman on 4/12/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75.0
        
        // Configure navigation bar.
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(red: 62.0 / 255.0, green: 204.0 / 255.0, blue: 1.0, alpha: 1.0)
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor.white
            ]
        }

        TwitterClient.sharedInstance?.homeTimeline(sucess: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTweetSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
        
            let tweetViewController = segue.destination as! TweetViewController
            tweetViewController.tweet = tweet
        }
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
