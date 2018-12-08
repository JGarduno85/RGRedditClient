//
//  RGSession.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/25/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation

// MARK: - Session
public protocol RGSession {
    func dataTask(request: RGRequestable, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTask
}

extension URLSession: RGSession {
    public func dataTask(request: RGRequestable, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTask {
        return dataTask(with: request.urlRequestValue, completionHandler: completion) as DataTask
    }
}

// MARK: - Data Task
public protocol DataTask {
    func suspend()
    func resume()
    func cancel()
}

extension URLSessionDataTask: DataTask {}

public class MockDataTask: DataTask {
    public func suspend() {}
    public func resume() {}
    public func cancel() {}
}

public class MockSession: RGSession {
    public var data: Data?
    public var error: Error?
    public var request: URLRequest?
    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }
    public func dataTask(request: RGRequestable, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTask {
        self.request = request.urlRequestValue
        completion(data,nil,error)
        return MockDataTask()
    }
}



