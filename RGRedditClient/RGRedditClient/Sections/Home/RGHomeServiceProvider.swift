//
//  RGHomeServiceProvider.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/25/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation

protocol RGHomeServiceProviding {
    func getHomeFeeds(completed:@escaping (RGFeedContainer?,Error?) -> Void)
}

class RGHomeServiceProvider: RGHomeServiceProviding {
    private init() {
        self.paginator = RGHomeServicePaginator()
        if ProcessInfo.processInfo.environment["UNIT_TEST_MODE"] != nil {
            client = MockNetworkClient.createMockClient(jsonFile: "topRedditFeed", bundleId: "com.hpx.RGRedditClientTests")
            return
        }
        client = createNetworkClient()
    }
    
    static func createHomeServiceProvider() -> RGHomeServiceProvider {
        return RGHomeServiceProvider()
    }
    
    fileprivate var client: RGNetworkClient?
    fileprivate (set) var paginator: RGHomeServicePaginator?
    
    var homeServicePaginator: RGHomeServicePaginator? {
        get {
            return paginator
        }
    }
    
    func getHomeFeeds(completed:@escaping (RGFeedContainer?,Error?) -> Void) {
        assert((client != nil), "networkClient couldn't be created")
        guard let client = client else {
            return
        }
        setClientQueryParameters()
        client.getResults(success: { [weak self] (data, response) in
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
                if let after = feeds?.data?.after {
                    self?.paginator?.pushNextPage(page: RGHomeServicePage(page: after))
                }
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

extension RGHomeServiceProvider {
    fileprivate func createNetworkClient() -> RGNetworkClient?  {
        guard let url = RGNetworkHomeHelper.homeBaseUrl() else {
            return nil
        }
        return RGNetworkClient.createRGNetworkClient(withBaseUrl: url, andSession: nil)
    }
    
    fileprivate func setClientQueryParameters() {
        if let nextPageQuery = paginator?.popLastPage() {
            var queryDic = [nextPageQuery.homeQueryLimitKey: nextPageQuery.pageLimit]
            if let page = nextPageQuery.page, !page.isEmpty {
                queryDic[nextPageQuery.homeQueryPageKey] = page
            }
            client?.setClientQueryParameters(query: queryDic)
        }
    }
}


extension RGHomeServiceProvider {
    fileprivate func createPaginator() {
        self.paginator = RGHomeServicePaginator()
    }
    
    struct RGHomeServicePage {
        let homeQueryLimitKey     = "limit"
        let homeQueryPageKey      = "after"
        var page: String?
        var pageLimit = "50"
        
        var pageQuery: String? {
            guard let page = page, !page.isEmpty else {
                return "\(homeQueryLimitKey)=\(pageLimit)"
            }
            return "\(homeQueryLimitKey)=\(pageLimit)&\(homeQueryPageKey)=\(page)"
        }

        init(page:String?) {
            self.page = page
        }
    }
    
    struct RGHomeServicePaginator {
        var pages:[RGHomeServicePage] = []
        var lastPage: RGHomeServicePage? {
            return pages.last
        }
        
        init() {
            pushNextPage(page: RGHomeServicePage(page: ""))
        }
        
        mutating func pushNextPage(page: RGHomeServicePage) {
            pages.append(page)
        }
        
        mutating func popLastPage() -> RGHomeServicePage? {
            return pages.popLast()
        }
    }
}

struct MockNetworkClient {
    static func createMockClient(jsonFile: String, bundleId: String) -> RGNetworkClient? {
        guard let url = RGNetworkHomeHelper.homeBaseUrl() else {
            return nil
        }
        guard let bundle = Bundle(identifier: bundleId) else {
            return nil
        }
        do {
            let data = try RGDataMocker.createRGDataMocker().retrievepostFeed(fromJsonFile: jsonFile, bundle: bundle)
            let mockSession = MockSession(data: data, error: nil)
            return RGNetworkClient.createRGNetworkClient(withBaseUrl: url, andSession: mockSession)
        } catch {
            return nil
        }
    }
}
