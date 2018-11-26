//
//  RGRequestTests.swift
//  RGRedditClientTests
//
//  Created by Jose Humberto Partida Garduno on 11/25/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import XCTest
@testable import RGRedditClient

class RGRequestTests: XCTestCase {
    //sut: System Under Test
    var sut: RGRequest!
    
    func testIfRequestParametersSetCreateIt() {
        guard let baseUrl = URL(string: "https://www.reddit.com/r/all/top/.json?count=50") else {
            XCTFail("Bad formed URL")
            return
        }
        sut = RGRequest.createRGRequest(withURL: baseUrl, method: .GET)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.method, .GET)
        XCTAssertEqual(sut.requestURL, baseUrl)
        XCTAssertEqual(sut.method, RGMethod.GET)
    }
}
