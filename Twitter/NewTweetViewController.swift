//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Will Gilman on 4/14/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var newTweetView: NewTweetView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var user: User!
    var remainingCharCount: Int!
    
    let remainingCharacters = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
    let tweetButton = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = User.currentUser
        newTweetView.user = user
        
        tweetTextView.delegate = self
        
        // Configure navigation bar.
        remainingCharacters.text = "140"
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != nil {
            remainingCharCount = 140 - textView.text!.characters.count
        } else {
            remainingCharCount = 140
        }
        remainingCharacters.text = "\(remainingCharCount!)"
        let remainingCharsButton = UIBarButtonItem(customView: remainingCharacters)
        navigationItem.setRightBarButtonItems([tweetButton, remainingCharsButton], animated: false)
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
