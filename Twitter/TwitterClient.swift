//
//  TwitterClient.swift
//  Twitter
//
//  Created by Will Gilman on 4/12/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "wwpAokluoHH5jGUgbFG0iOBIG", consumerSecret: "HlPNOV8IooDU9vjCs0RSwvHfXRPebro9iC834FCSgnaKq5LD8v")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
            
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitter://oauth")!, scope: nil,
            success: { (requestToken: BDBOAuth1Credential?) -> Void in
                                                            
                let token = requestToken?.token
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token!)")!
                UIApplication.shared.open(url)
            },
            failure: { (error: Error?) -> Void in
                                                            
                self.loginFailure?(error!)
            }
        )
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential?) in
                
                self.currentAccount(success: { (user: User) in
                    
                    User.currentUser = user
                    self.loginSuccess?()
                    
                }, failure: { (error: Error) in
                    self.loginFailure?(error)
                })
            },
            failure: { (error:Error?) in
                
                self.loginFailure?(error!)
                print("error: \(error?.localizedDescription)")
            }
        )

    }
    
    func homeTimeline(sucess: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask?, response: Any?) in
            
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                sucess(tweets)
            },
            failure: { (task: URLSessionDataTask?, error: Error?) in
                                            
                failure((error)!)
            }
        )
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask?, response: Any?) in
                
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                success(user)
            },
            failure: { (task: URLSessionDataTask?, error: Error?) in
                
                failure((error)!)
            }
        )
    }
    
    func tweet(status: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        reply(status: status, reply_id: nil, success: success, failure: failure)
    }
    
    func reply(status: String, reply_id: String?, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        var parameters: [String : String] = ["status" : status]
        
        if reply_id != nil {
            parameters["in_reply_to_status_id"] = reply_id
        }
        
        post("1.1/statuses/update.json", parameters: parameters, progress: nil,
            success: { (task: URLSessionDataTask?, response: Any?) in
                
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                success(tweet)
            },
            failure: { (task: URLSessionDataTask?, error: Error?) in
                
                failure((error)!)
            }
        )
    }
    
    func retweet(id: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: ["id" : id], progress: nil,
            success: { (task: URLSessionDataTask?, response: Any?) in
                
                let dictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: dictionary)
                success(tweet)
            },
            failure: { (task: URLSessionDataTask?, error: Error?) in
                
                failure((error)!)
            }
        )
    }
    
    func unfavorite(id: String, action: String?, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        favorite(id: id, action: "destroy", success: success, failure: failure)
    }
    
    func favorite(id: String, action: String?, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        let method = action ?? "create"
        post("1.1/favorites/\(method).json?id=\(id)", parameters: ["id" : id], progress: nil,
             success: { (task: URLSessionDataTask?, response: Any?) in
    
                let resp = response as! NSDictionary
                success(resp)
            },
            failure: { (task: URLSessionDataTask?, error: Error?) in
    
            failure((error)!)
            }
        )
    }

}
