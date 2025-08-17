//
//  TopicResponse.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import Foundation

struct TopicResponse: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: TopicURL
    let likes: Int
    let user: User
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case likes
        case user
    }
    
    var formattedLikes: String {
        return likes.formatted(.number)
    }
}

struct TopicURL: Decodable {
    let raw: String
    let small: String?
}
