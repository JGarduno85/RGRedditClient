//
//  ViewController.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/20/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import UIKit

class RGHome: UIViewController {

    let homeDataServiceProvider: HomeServiceProviding = HomeServiceProvider.createHomeServiceProvider()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        homeDataServiceProvider.getHomeFeeds { (feeds, error) in
            if error == nil {
                //TODO: Show error message
            }
            
            guard let feeds = feeds else {
                return
            }
            print("\(feeds)")
        }
    }


}

