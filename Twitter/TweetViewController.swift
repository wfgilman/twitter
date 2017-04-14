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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
