//
//  Tweet.swift
//  Twitter
//
//  Created by Will Gilman on 4/12/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: Date?
    var timestampDate: String?
    var timestampDateTime: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    
    init(dictionary: NSDictionary) {
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
            formatter.dateFormat = "MM/dd/yy H:mm a"
            timestampDateTime = formatter.string(from: timestamp! as Date)
            formatter.dateFormat = "MM/dd/yy"
            timestampDate = formatter.string(from: timestamp! as Date)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }

}
