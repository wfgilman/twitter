//
//  TweetCell.swift
//  Twitter
//
//  Created by Will Gilman on 4/13/17.
//  Copyright © 2017 Will Gilman. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            screennameLabel.text = "@\((tweet.user?.screenname)!)"
            tweetTextLabel.text = tweet.text
            userImageView.setImageWith((tweet.user?.profileUrl)!)
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                self.userImageView.alpha = 1.0
            })
        }
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        screennameLabel.text = nil
        tweetTextLabel.text = nil
        userImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
