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
    func testGetFeeds() {
        
    }
}


extension RGHomeServiceProviderTests {
    class ClientMocker: RGNetworkFetchable {
        func getResults(success: @escaping (_ data: Data?,_ response: URLResponse?) -> Void,fail: @escaping (_ response: URLResponse?,_ error: Error?) -> Void) {
            
        }
    }
}
