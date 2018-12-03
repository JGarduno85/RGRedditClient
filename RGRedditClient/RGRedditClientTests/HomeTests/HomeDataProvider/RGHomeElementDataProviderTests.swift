//
//  RGHomeElementDataProviderTests.swift
//  RGRedditClientTests
//
//  Created by Jose Humberto Partida Garduno on 12/2/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import XCTest
@testable import RGRedditClient

class RGHomeElementDataProviderTests: XCTestCase {
    var sut: RGHomeSectionDataProvider!
    var homeMock: RGHomeMock!
    override func setUp() {
        sut = RGHomeSectionDataProvider()
        homeMock = RGHomeMock()
        homeMock.tableView.dataSource = sut
        homeMock.tableView.delegate = sut
    }
    
    func testIfErrorSectionInsertedOrRemovedInDirectorNumberOfRowsShouldIncreaseAndDecrease() {
        let errorSection = RGErrorPresenter()
        sut.homeSectionDirector.insertSection(section: errorSection)
        var numberOfRows = sut.tableView(homeMock.tableView, numberOfRowsInSection: 0)
        homeMock.tableView.reloadData()
        XCTAssertEqual(numberOfRows, sut.homeSectionDirector.sectionsCount, "Number of rows should be equal to number of elements inserted in section Count")
        sut.homeSectionDirector.removeSection(section: errorSection)
        homeMock.tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        homeMock.tableView.reloadData()
        numberOfRows = sut.tableView(homeMock.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, sut.homeSectionDirector.sectionsCount, "Number of rows should be equal to number of elements removed in section Count")
    }
    
    func testIfFeedSectionInsertedInDirectorNumberOfRowsShouldIncrease() {
        let feed1 = FeedFactory.createFeed(with: "This is a example title feed 1", author: "my self1", createdTimeUTC: 10000, thumbnail: nil, numberComments: 345)
        let feed2 = FeedFactory.createFeed(with: "This is a example title feed2", author: "my self2", createdTimeUTC: 20000, thumbnail: nil, numberComments: 245)
        homeMock.tableView.register(RGFeedTableViewCell.self, forCellReuseIdentifier: RGFeedPresenter.id)
        sut.homeSectionDirector.insertSection(section: feed1)
        sut.homeSectionDirector.insertSection(section: feed2)
        let numberOfRows = sut.tableView(homeMock.tableView, numberOfRowsInSection: 0)
        homeMock.tableView.reloadData()
        
        let dequeCellFeed1 = homeMock.tableView.dequeueReusableCell(withIdentifier: RGFeedPresenter.id, for: IndexPath(row: 0, section: 0))
        
        let dequeCellFeed2 = homeMock.tableView.dequeueReusableCell(withIdentifier: RGFeedPresenter.id, for: IndexPath(row: 1, section: 0))
        XCTAssertNotNil(dequeCellFeed1)
        XCTAssertTrue(dequeCellFeed1 is RGFeedTableViewCell)
        XCTAssertNotNil(dequeCellFeed2)
        XCTAssertTrue(dequeCellFeed2 is RGFeedTableViewCell)
        XCTAssertEqual(numberOfRows, sut.homeSectionDirector.sectionsCount, "Number of rows should be equal to number of elements inserted in section Count")
    }
}


extension RGHomeElementDataProviderTests {
    class RGHomeMock {
        var tableView: UITableView!
        init() {
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), style: .plain)
        }
    }
}

struct FeedFactory {
    static func createFeed(with title: String, author: String, createdTimeUTC: TimeInterval?, thumbnail: String?, numberComments: Int?) -> RGFeed {
        let feed = RGFeed()
        feed.title = title
        feed.author_fullname = author
        feed.created_utc = createdTimeUTC
        feed.thumbnail = thumbnail
        feed.num_comments = numberComments
        return feed
    }
}
