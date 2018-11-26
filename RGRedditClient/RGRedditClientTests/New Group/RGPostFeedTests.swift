//
//  RGPostFeedTests.swift
//  RGRedditClientTests
//
//  Created by Jose Humberto Partida Garduno on 11/22/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import XCTest
@testable import RGRedditClient

class RGPostFeedTests: XCTestCase {
    var rgPostMocker: RGPostMocker!
    
    override func setUp() {
        rgPostMocker = RGPostMocker.createRGPostMocker()
    }
    
    func testIfFeedCreatedVariablesAreSet() {
        let rootContainer = try! rgPostMocker.retrievepostFeed(fromJsonFile: "topRedditFeed")
        let feeds = RGPostDataExtractor().extractFeeds(from: rootContainer)
        guard let sut = feeds?.first?.data else {
            fatalError("No data feeds in this json")
        }
        let jsonMockData = RGJsonMockData(title: "\"Ooh, I know this one!\"", thumbnail: "https://b.thumbs.redditmedia.com/HRVGekopDIUyLBOF6-A87F161n8aojmgwNP4W0ksElY.jpg", author_fullname: "t2_1jgbe6yc", num_comments: 554, created_utc: 1542899845)
        assertSetValues(of: sut, withJsonMock: jsonMockData)
        assertNotNullity(of: sut)
    }
    
    fileprivate func assertSetValues(of feed:RGFeed, withJsonMock jsonMock: RGJsonMockData) {
        XCTAssertEqual(feed.title!, jsonMock.title)
        XCTAssertEqual(feed.author_fullname!, jsonMock.author_fullname)
        XCTAssertEqual(feed.thumbnail, jsonMock.thumbnail)
        XCTAssertEqual(feed.num_comments, jsonMock.num_comments)
        XCTAssertEqual(feed.created_utc, jsonMock.created_utc)
    }
    
    fileprivate func assertNotNullity(of feed: RGFeed) {
        XCTAssertNotNil(feed.title, "this feed does not have a title")
        XCTAssertNotNil(feed.thumbnail, "this feed does not have a thumbnail")
        XCTAssertNotNil(feed.author_fullname, "this feed does not have an author full name")
        XCTAssertNotNil(feed.num_comments, "this feed does not have comments")
        XCTAssertNotNil(feed.created_utc, "this feed does not have a created time")
    }
}

extension RGPostFeedTests {
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
}


extension RGPostFeedTests {
    class RGPostMocker {
        fileprivate init() {}
        static public func createRGPostMocker() -> RGPostMocker {
           return RGPostMocker()
        }
        
        func retrievepostFeed(fromJsonFile json: String)throws -> RGFeedContainer {
            let bundle = Bundle(for: type(of: self))
            guard let path = bundle.path(forResource: json, ofType: "json") else {
                throw RGPostMockerError.fileNotFound
            }
            
            let pathUrl = URL(fileURLWithPath: path)
            do {
                let jsonData = try Data(contentsOf: pathUrl, options: .alwaysMapped)
                let result = try JSONDecoder().decode(RGFeedContainer.self, from: jsonData)
                return result
            } catch {
                throw RGPostMockerError.canNotDecodeDataIntoModel
            }
        }
    }
    
    enum RGPostMockerError: Error {
        case fileNotFound
        case canNotDecodeDataIntoModel
    }
}


