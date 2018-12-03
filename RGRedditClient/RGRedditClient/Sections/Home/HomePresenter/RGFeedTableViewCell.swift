//
//  RGFeedTableViewCell.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/30/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import UIKit

class RGFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comments: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with feed:RGFeed) {
        title.text = feed.title
        author.text = feed.author_fullname
        configureTime(for: feed)
        configureComments(from: feed)
    }
    
    fileprivate func configureTime(for feed: RGFeed) {
        guard let timeUTC = feed.created_utc else {
            return
        }
        time.text = getTimeStr(from: timeUTC)
    }
    
    fileprivate func configureComments(from feed: RGFeed) {
        guard let numberOfComments = feed.num_comments, numberOfComments > 0 else {
            return
        }
        comments.text = comments(fromNumber: numberOfComments)
    }
    
    fileprivate func getTimeStr(from interval: TimeInterval) -> String {
        let time = Int(floor(interval / 3600))
        return "\(time) hours ago"
    }
    
    fileprivate func comments(fromNumber number: Int) -> String {
        return "\(number)Comments"
    }
    
}
