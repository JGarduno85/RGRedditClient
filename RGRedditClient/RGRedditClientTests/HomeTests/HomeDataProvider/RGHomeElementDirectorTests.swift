//
//  RGHomeElementDirectorTests.swift
//  RGRedditClientTests
//
//  Created by Jose Humberto Partida Garduno on 12/2/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import XCTest
@testable import RGRedditClient

class RGHomeElementDirectorTests: XCTestCase {
    var sut: RGHomeElementDirector!
    
    override func setUp() {
        sut = RGHomeElementDirector()
    }
    
    func testIfElementInsertedCountIsIncreasedIfRemovedCountIsDecreased() {
        let feed1 = FeedFactory.createFeed(with: "This is a example title feed 1", author: "my self1", createdTimeUTC: 10000, thumbnail: nil, numberComments: 345)
        let feed2 = FeedFactory.createFeed(with: "This is a example title feed2", author: "my self2", createdTimeUTC: 20000, thumbnail: nil, numberComments: 245)
        let feedDataContainer1 = FeedDataContainerFactory.createFeedDataContainer(with: feed1)
        let feedDataContainer2 = FeedDataContainerFactory.createFeedDataContainer(with: feed2)
        XCTAssertTrue(sut.sectionsAreEmpty)
        sut.insertSection(section: feedDataContainer1)
        sut.insertSection(section: feedDataContainer2)
        XCTAssertEqual(sut.sectionsRegisteredCount,1, "When a new section is inserted it should be registered in the table, check that the Section type is supported")
        XCTAssertEqual(sut.sectionsCount, 2)
        
        sut.removeSection(section: feedDataContainer1)
        XCTAssertEqual(sut.sectionsCount, 1)
        XCTAssertEqual(sut.sectionsRegisteredCount, 1, "If a section is removed but there is more than one of the same section in the array the number of sections registered should remain the same for this case")
        
        sut.removeSection(section: feedDataContainer2)
        XCTAssertEqual(sut.sectionsCount, 0)
        XCTAssertEqual(sut.sectionsRegisteredCount, 0, "If a section is removed and there is more of the same section in the array the sections registered should be zero")
    }
}

extension RGHomeElementDirectorTests {
    class FeedDataContainerFactory {
        static func createFeedDataContainer(with feed: RGFeed) -> RGFeedDataContainer {
            let feedDataContainer = RGFeedDataContainer()
            feedDataContainer.data = feed
            return feedDataContainer
        }
    }
}
