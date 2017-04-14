//
//  NewTweetView.swift
//  Twitter
//
//  Created by Will Gilman on 4/14/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import UIKit

class NewTweetView: UIView {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    
    var user: User! {
        didSet {
            userImageView.setImageWith(user.profileUrl!)
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                self.userImageView.alpha = 1.0
            })
            nameLabel.text = user.name
            screennameLabel.text = user.screenname
        }
    }
        

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
