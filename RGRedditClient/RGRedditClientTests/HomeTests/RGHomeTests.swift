//
//  RGHomeTests.swift
//  RGRedditClientTests
//
//  Created by Jose Humberto Partida Garduno on 11/27/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import XCTest
@testable import RGRedditClient

class RGHomeTests: XCTestCase {
    var sut: RGHome!
    override func setUp() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        sut = storyBoard.instantiateViewController(withIdentifier: "RGHomeController") as? RGHome
    }
    
    func testRGHomeSectionLoads() {
        _ = sut.view
        XCTAssertNotNil(sut.homeSectionTableView)
        XCTAssert(sut.homeSectionTableView.dataSource is RGHomeSectionDataProvider)
        XCTAssert(sut.homeSectionTableView.delegate is RGHomeSectionDataProvider)
        XCTAssertNotNil(sut.errorSection)
    }
}
