//
//  RGFeedResponsParserMock.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/26/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation

struct RGPostDataExtractor {
    func extractFeeds(from rootContainer: RGFeedContainer) -> [RGFeedDataContainer]? {
        guard let rootContainerData = rootContainer.data else {
            return nil
        }
        return rootContainerData.children
    }
}

struct RGJsonMockData {
    var title:String
    var thumbnail: String
    var author_fullname: String
    var num_comments: Int
    var created_utc: TimeInterval
}


class RGDataMocker {
    fileprivate init() {}
    static public func createRGDataMocker() -> RGDataMocker {
        return RGDataMocker()
    }
    
    func retrievepostFeed(fromJsonFile json: String, bundle: Bundle)throws -> Data {
        guard let path = bundle.path(forResource: json, ofType: "json") else {
            throw RGDataMockerError.fileNotFound
        }
        
        let pathUrl = URL(fileURLWithPath: path)
        do {
            let jsonData = try Data(contentsOf: pathUrl, options: .alwaysMapped)
            return jsonData
        } catch {
            throw RGDataMockerError.canNotGetData
        }
    }
}

enum RGDataMockerError: Error {
    case fileNotFound
    case canNotGetData
}
