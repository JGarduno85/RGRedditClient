//
//  RGLoaderTableViewCell.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/28/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import UIKit

class RGLoaderTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commonInit()
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    fileprivate func commonInit() {
        activityIndicator.hidesWhenStopped = true
        startAnimating()
    }
    
    deinit {
        stopAnimating()
    }
}
