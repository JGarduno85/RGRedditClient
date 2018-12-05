//
//  RGImageDownloader.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 12/4/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation
import UIKit


struct RGImageDownloader {
    typealias imageSuccess = (UIImage?) -> Void
    typealias imageFail = (Error?) -> Void
    static var imageCache = NSCache<AnyObject, AnyObject>()
    static func downloadImage(from url: String, success: @escaping imageSuccess, fail: @escaping imageFail)  {
        if let imageFromCache = RGImageDownloader.imageCache.object(forKey: url as AnyObject) as? UIImage {
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
