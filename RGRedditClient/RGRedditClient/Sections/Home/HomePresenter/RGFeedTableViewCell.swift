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
    
    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(thumbnailTap(_:)))
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
    fileprivate lazy var longPress: UILongPressGestureRecognizer = {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(savePhoto(_:)))
        return longPress
    }()
    
    
    
    override func awakeFromNib() {
        commonInit()
    }
    
    private func commonInit() {
        title.text = ""
        author.text = ""
        time.text = ""
        comments.text = ""
        thumbnail.imageView?.image = nil
    }
    
    override func prepareForReuse() {
       resetCell()
    }
    
    func configure(with feed:RGFeed) {
        title.text = feed.title
        author.text = feed.author_fullname
        configureTime(for: feed)
        configureComments(from: feed)
        configureThumbnail(from: feed)
        imageFromThumbnail = feed.url
    }
    
    @objc fileprivate func savePhoto(_ sender: Any) {
       
    }
    
    @objc fileprivate func thumbnailTap(_ sender: Any) {
        guard let imageFromThumbnail = imageFromThumbnail, let url = URL(string: imageFromThumbnail) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    fileprivate func resetCell() {
        title.text = ""
        author.text = ""
        time.text = ""
        comments.text = ""
        thumbnail.imageView?.image = nil
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
        thumbnail.addGestureRecognizer(tapGesture)
        thumbnail.addGestureRecognizer(longPress)
        RGFeedTableViewCell.downloadImage(from: thumbnailString, success: { [weak self] (image) in
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


extension RGFeedTableViewCell {
    typealias imageSuccess = (UIImage?) -> Void
    typealias imageFail = (Error?) -> Void
    static var imageCache = NSCache<AnyObject, AnyObject>()
    static func downloadImage(from url: String, success: @escaping imageSuccess, fail: @escaping imageFail)  {
        if let imageFromCache = RGFeedTableViewCell.imageCache.object(forKey: url as AnyObject) as? UIImage {
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
