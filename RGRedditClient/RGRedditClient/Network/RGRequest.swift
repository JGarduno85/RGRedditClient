//
//  RGRequest.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/25/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation

public enum RGMethod: String {
    case GET,POST
}

public protocol RGRequestable {
    var method: RGMethod { get }
    var requestURL:URL { get }
    var urlRequestValue: URLRequest { get }
}


struct RGRequest: RGRequestable {
    private var localMethod: RGMethod
    private var localRequestURL:URL
    
    public var method: RGMethod {
        return localMethod
    }
    
    public var requestURL: URL {
        return localRequestURL
    }
    
    private init(withUrl url: URL, method: RGMethod) {
        self.localRequestURL = url
        self.localMethod = method
    }
    
    public static func createRGRequest(withURL url: URL,method: RGMethod) -> RGRequest {
        return RGRequest(withUrl: url, method: method)
    }
    
    public var urlRequestValue: URLRequest {
        let urlRequest = NSMutableURLRequest(url: localRequestURL)
        urlRequest.httpMethod = method.rawValue
        return urlRequest.copy() as! URLRequest
    }
}
