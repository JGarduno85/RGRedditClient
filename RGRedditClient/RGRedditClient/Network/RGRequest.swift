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
    var queryParameters: [String: String]? { get set }
}


struct RGRequest: RGRequestable {
    private var localMethod: RGMethod
    private var localRequestURL:URL
    private var localQueryParameters: [String: String]?
    
    public var method: RGMethod {
        return localMethod
    }
    
    public var requestURL: URL {
        return localRequestURL
    }
    
    public var queryParameters: [String: String]? {
        set {
            localQueryParameters = newValue
        }
        get {
            return localQueryParameters
        }
    }
    
    private init(withUrl url: URL, method: RGMethod) {
        self.localRequestURL = url
        self.localMethod = method
    }
    
    public static func createRGRequest(withURL url: URL,method: RGMethod) -> RGRequest {
        return RGRequest(withUrl: url, method: method)
    }
    
    public var urlRequestValue: URLRequest {
        var url: URL = localRequestURL
        if let query =  queryParameters, !query.isEmpty {
            var components: [URLQueryItem] = []
            var urlComponents = URLComponents(url: localRequestURL, resolvingAgainstBaseURL: false)
            for component in query {
                components.append(URLQueryItem(name: component.key, value: component.value))
            }
            urlComponents?.queryItems = components
            if let urlFromComponents = urlComponents?.url {
                url = urlFromComponents
            }
        }
        
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest.copy() as! URLRequest
    }
}
