//
//  RGNetworkClientTests.swift
//  RGRedditClientTests
//
//  Created by Jose Humberto Partida Garduno on 11/25/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import XCTest
@testable import RGRedditClient

class RGNetworkClientTests: XCTestCase {
    var baseUrl: String!
    var bundle: Bundle!
    override func setUp() {
        bundle = Bundle(for: type(of: self))
        baseUrl = "https://www.reddit.com/r/all/top/.json?count=50"
    }
    
    func testSuccessCalledIfErrorNil() {
        let session = MockSession(data:Data(),error:nil)
        guard let url = URL(string: baseUrl) else {
            XCTFail("Couldn't create the URL")
            return
        }
        assertClientCallBackReponseElementsNotNil(withUrl: url, andSession: session)
    }
    
    func testFailCalledIfErrorNotNil() {
        let session = MockSession(data: nil, error: NSError(domain: "Internal error", code: 500, userInfo: nil))
        guard let url = URL(string: baseUrl) else {
            XCTFail("Couldn't create the URL")
            return
        }
        assertClientCallBackReponseElementsNotNil(withUrl: url, andSession: session)
    }
    
    func testIfRequestMockedDataRetrieveIt() {
        
        let data = try! RGDataMocker.createRGDataMocker().retrievepostFeed(fromJsonFile: "topRedditFeed", bundle: bundle)
        let session = MockSession(data: data, error: nil)
        guard let url = URL(string: baseUrl) else {
            XCTFail("Couldn't create the URL")
            return
        }
        let sut = RGNetworkClient.createRGNetworkClient(withBaseUrl: url, andSession: session)
        sut.getResults(success: { (data, response) in
            guard let data = data else {
                XCTFail("Data is nil")
                return
            }
            let result = try! JSONDecoder().decode(RGFeedContainer.self, from: data)
            guard let title = result.data?.children?.first?.data?.title else {
                XCTFail("No title in this data")
                return
            }
            XCTAssertEqual(title, "\"Ooh, I know this one!\"")
        }) { (response, error) in }
    }
    
    fileprivate func assertClientCallBackReponseElementsNotNil(withUrl url:URL, andSession session: RGSession) {
        let sut = RGNetworkClient.createRGNetworkClient(withBaseUrl:url, andSession: session)
        sut.getResults(success: { (data, response) in
            XCTAssertNotNil(data)
        }) { (response, error) in
            XCTAssertNotNil(error)
        }
    }
}
