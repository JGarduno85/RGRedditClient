//
//  RGPostFeed.swift
//  RGRedditClient
//
//  Created by Jose Humberto Partida Garduno on 11/22/18.
//  Copyright © 2018 Jose Humberto Partida Garduno. All rights reserved.
//

import Foundation

class RGFeedContainer: Decodable {
    var data: RGFeedElement?
    
    enum FeedContainerKeys: String, CodingKey {
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let container                   = try decoder.container(keyedBy: FeedContainerKeys.self)
        self.data                       = try container.decodeIfPresent(RGFeedElement.self, forKey: .data)
    }
}

class RGFeedElement: Codable {
    var children: [RGFeedDataContainer]?
    var after: String?
    
    enum FeedContainerKeys: String, CodingKey {
        case children
        case after
    }
    
    init(after: String?, children: [RGFeedDataContainer]?) {
        self.children = children
        self.after = after
    }
    
    required init(from decoder: Decoder) throws {
        let container               = try decoder.container(keyedBy: FeedContainerKeys.self)
        self.children               = try container.decodeIfPresent([RGFeedDataContainer].self, forKey: .children)
        self.after                  = try container.decodeIfPresent(String.self, forKey: .after)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FeedContainerKeys.self)
        try container.encode(children, forKey: .children)
    }
}

class RGFeedDataContainer: Codable {
    var data: RGFeed?
    
    enum FeedContainerKeys: String, CodingKey {
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let container                   = try decoder.container(keyedBy: FeedContainerKeys.self)
        self.data                       = try container.decodeIfPresent(RGFeed.self, forKey: .data)
    }
    
    init() { }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FeedContainerKeys.self)
        try container.encode(data, forKey: .data)
    }
}

class RGFeed: Codable {
    var title: String?
    var author_fullname: String?
    var created_utc: TimeInterval?
    var thumbnail: String?
    var num_comments: Int?
    var url: String?
    
    enum FeedKeys: String, CodingKey {
        case title, author_fullname = "author", created_utc, thumbnail, num_comments, url
    }
    
    required init(from decoder: Decoder) throws {
        let container               = try decoder.container(keyedBy: FeedKeys.self)
        self.title                  = try container.decodeIfPresent(String.self, forKey: .title)
        self.author_fullname        = try container.decodeIfPresent(String.self, forKey: .author_fullname)
        self.created_utc            = try container.decodeIfPresent(TimeInterval.self, forKey: .created_utc)
        self.thumbnail              = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        self.num_comments           = try container.decodeIfPresent(Int.self, forKey: .num_comments)
        self.url                    = try container.decodeIfPresent(String.self, forKey: .url)
    }
    
    init() {}
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FeedKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(author_fullname, forKey: .author_fullname)
        try container.encode(created_utc, forKey: .created_utc)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(num_comments, forKey: .num_comments)
        try container.encode(url, forKey: .url)
    }
}
