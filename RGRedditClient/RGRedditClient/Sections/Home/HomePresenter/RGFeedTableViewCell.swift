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
    @IBOutlet weak var thumbnail: UIButton!
    var imageFromThumbnail: String?
    
    override func prepareForReuse() {
        title.text = ""
        author.text = ""
        time.text = ""
        comments.text = ""
        thumbnail.imageView?.image = nil
    }
    
    func configure(with feed:RGFeed) {
        title.text = feed.title
        author.text = feed.author_fullname
        configureTime(for: feed)
        configureComments(from: feed)
        configureThumbnail(from: feed)
        imageFromThumbnail = feed.url
    }
    @IBAction func thumbnailTap(_ sender: Any) {
        guard let imageFromThumbnail = imageFromThumbnail, let url = URL(string: imageFromThumbnail) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
    
    fileprivate func configureThumbnail(from feed: RGFeed) {
        guard let thumbnailString = feed.thumbnail else {
            thumbnail.isHidden = true
            return
        }
        UIImage.downloadImage(from: thumbnailString, success: { [weak self] (image) in
            self?.thumbnail.setImage(image, for: .normal)
            self?.thumbnail.setImage(image, for: .selected)
            self?.thumbnail.setNeedsDisplay()
        }, fail: { (error) in
            
        })
    }
    
    fileprivate func getTimeStr(from interval: TimeInterval) -> String {
        let time = Int(floor(interval / 3600))
        return "\(time) hours ago"
    }
    
    fileprivate func comments(fromNumber number: Int) -> String {
        return "\(number)Comments"
    }
}


extension UIImage {
    typealias imageSuccess = (UIImage?) -> Void
    typealias imageFail = (Error?) -> Void
    static var imageCache = NSCache<AnyObject, AnyObject>()
    static func downloadImage(from url: String, success: @escaping imageSuccess, fail: @escaping imageFail)  {
        if let imageFromCache = UIImage.imageCache.object(forKey: url as AnyObject) as? UIImage {
            success(imageFromCache)
            return
        }
        guard let baseURL = URL(string: url) else {
            return fail(nil)
        }
        let client = RGNetworkClient.createRGNetworkClient(withBaseUrl: baseURL, andSession: nil)
        client.getResults(success: { (data, response) in
            var image: UIImage?
            if let data = data {
               image = UIImage(data: data)
            }
            success(image)
        }) { (response, error) in
            fail(error)
        }
    }
}
