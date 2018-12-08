//
//  RGFeedResponseParser.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/25/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation

class RGResponseParser {
    fileprivate init() {}
    static public func createRGResponseParser() -> RGResponseParser {
        return RGResponseParser()
    }
    
    func retrievepostFeed(fromData data: Data) throws -> RGFeedContainer {
        do {
            let result = try JSONDecoder().decode(RGFeedContainer.self, from: data)
            return result
        } catch {
            throw RGResponseParserError.canNotDecodeDataIntoModel
        }
    }
}

enum RGResponseParserError: Error {
    case fileNotFound
    case canNotDecodeDataIntoModel
}
