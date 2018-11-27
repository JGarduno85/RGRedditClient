//
//  RGHomeServiceProviderTests.swift
//  RGRedditClientTests
//
//  Created by Jose Humberto Partida Garduno on 11/25/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import XCTest
@testable import RGRedditClient

class RGHomeServiceProviderTests: XCTestCase {
    func testIfRequestFeedsGetFeeds() {
        let sut = RGHomeServiceProvider.createHomeServiceProvider()
        sut.getHomeFeeds { (feed, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(feed)
        }
    }
}
