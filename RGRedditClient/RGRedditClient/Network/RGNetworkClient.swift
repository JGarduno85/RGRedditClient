//
//  RGRequest.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/25/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation

public final class RGNetworkClient: NSObject {
    public static var defaultSession: RGSession = URLSession.shared
    public lazy var session: RGSession = RGNetworkClient.defaultSession
    
    typealias ClientSuccess = (_ data: Data?,_ response: URLResponse?) -> Void
    typealias ClientFail = (_ response: URLResponse?,_ error: Error?) -> Void

    private var dataTask: DataTask?
    private var request: RGRequest
    // MARK: Initialization
    private init(baseURL: URL) {
        self.request = RGRequest.createRGRequest(withURL: baseURL, method: .GET)
        super.init()
    }
    
    static func createRGNetworkClient(withBaseUrl url: URL, andSession session: RGSession?) -> RGNetworkClient {
        let client = RGNetworkClient(baseURL: url)
        if let localSession = session {
            client.session = localSession
        }
        return client
    }
    
    func getResults(success: @escaping ClientSuccess,fail: @escaping ClientFail) {
        self.dataTask?.cancel()
        self.session.dataTask(request: self.request) { (data, response, error) in
            DispatchQueue.main.async {
                if error == nil {
                    success(data, response)
                } else {
                    fail(response, error)
                }
            }
        }.resume()
    }
}
