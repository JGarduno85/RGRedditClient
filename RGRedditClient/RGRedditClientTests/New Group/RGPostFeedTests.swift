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
    var rgPostMocker: RGDataMocker!
    var bundle: Bundle!

    override func setUp() {
        rgPostMocker = RGDataMocker.createRGDataMocker()
        bundle = Bundle(for: type(of: self))
    }

    func testIfFeedCreatedVariablesAreSet() {
        let rootData = try! rgPostMocker.retrievepostFeed(fromJsonFile: "topRedditFeed", bundle: bundle)
        let rootContainer = try! RGResponseParser.createRGResponseParser().retrievepostFeed(fromData: rootData)
        let feeds = RGPostDataExtractor().extractFeeds(from: rootContainer)
        guard let sut = feeds?.first?.data else {
            fatalError("No data feeds in this json")
        }
        let jsonMockData = RGJsonMockData(title: "\"Ooh, I know this one!\"", thumbnail: "https://b.thumbs.redditmedia.com/HRVGekopDIUyLBOF6-A87F161n8aojmgwNP4W0ksElY.jpg", author_fullname: "IMANICEGUY07", num_comments: 554, created_utc: 1542899845)
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


