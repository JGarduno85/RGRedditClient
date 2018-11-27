//
//  RGNetworkHelpers.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/25/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation

struct RGNetworkHomeHelper {
    static var homeBaseUrlString = "https://www.reddit.com/r/all/top/.json?limit="
    static func homeBaseUrl() -> URL? {
        return URL(string: homeBaseUrlString)
    }
}
