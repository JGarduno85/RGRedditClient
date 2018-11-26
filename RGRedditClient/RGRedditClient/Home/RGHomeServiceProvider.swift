//
//  RGHomeServiceProvider.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/25/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation

protocol HomeServiceProviding {
    func getHomeFeeds(completed:@escaping (RGFeedContainer?,Error?) -> Void)
}

class HomeServiceProvider: HomeServiceProviding {
    
    private init() {
        createNetworkClient()
    }
    
    static func createHomeServiceProvider() -> HomeServiceProvider {
        return HomeServiceProvider()
    }
    
    fileprivate var client: RGNetworkClient?
    
    func getHomeFeeds(completed:@escaping (RGFeedContainer?,Error?) -> Void) {
        assert((client != nil), "networkClient couldn't be created")
        guard let client = client else {
            return
        }
        client.getResults(success: { (data, response) in
            var parseError: NSError? = nil
            var feeds: RGFeedContainer? = nil
            guard let localData = data else {
               parseError = NSError(domain: "empty data", code: 1000, userInfo: nil)
               completed(nil, parseError)
               return
            }
            let parser = RGResponseParser.createRGResponseParser()
            do {
                feeds = try parser.retrievepostFeed(fromData: localData)
            } catch {
                parseError = NSError(domain: "parser error", code:10001, userInfo:nil)
            }
            DispatchQueue.main.async {
                completed(feeds, parseError)
            }
        }) { (response, error) in
            DispatchQueue.main.async {
                completed(nil,error)
            }
        }
    }
}

extension HomeServiceProvider {
    fileprivate func createNetworkClient() {
        guard let url = RGNetworkHomeHelper.homeBaseUrl() else {
            return
        }
        client = RGNetworkClient.createRGNetworkClient(withBaseUrl: url, andSession: nil)
    }
}
