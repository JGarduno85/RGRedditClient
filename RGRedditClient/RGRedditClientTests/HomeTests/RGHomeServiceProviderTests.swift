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
    
    func testIfNextPageRequestedShouldHaveAfterInQueryParameters() {
        let sut = RGHomeServiceProvider.createHomeServiceProvider()
        
        let expectationFirstCall = expectation(description: "First query to API")
        let expectationSecondCall = expectation(description: "Second query to API")
      
        
        sut.getHomeFeeds { (feed, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(feed)
            XCTAssertNotNil(sut.paginator)
            XCTAssertNotNil(sut.paginator?.pages)
            guard let lastPage = sut.paginator?.lastPage?.page else {
                XCTFail("paginator doesn't have reference to the next page")
                return
            }
            XCTAssertEqual(lastPage,"t3_9zeye9")
            expectationFirstCall.fulfill()
        }
        let result1 = XCTWaiter.wait(for: [expectationFirstCall], timeout: 5.0)
        XCTAssertEqual(result1, .completed, "Request were not completed")
        XCTAssertNotEqual(result1, .timedOut, "Requests timeout")
        XCTAssertNotEqual(result1, .incorrectOrder, "Request were fulfill on incorrect order")
        ///Next page
        sut.getHomeFeeds { (feed, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(feed)
            XCTAssertNotNil(sut.paginator)
            XCTAssertNotNil(sut.paginator?.pages)
            expectationSecondCall.fulfill()
        }
        let result2 = XCTWaiter.wait(for: [expectationSecondCall], timeout: 5.0)
        XCTAssertEqual(result2, .completed, "Request were not completed")
        XCTAssertNotEqual(result2, .timedOut, "Requests timeout")
        XCTAssertNotEqual(result2, .incorrectOrder, "Request were fulfill on incorrect order")
        
    }
}
