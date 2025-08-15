//
//  SearchResponse.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import Foundation

struct SearchResponse: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: SearchURL
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
}

struct SearchURL: Decodable {
    let raw: String
    let small: String
}

struct User: Decodable {
    let name: String
    let profileImage: Profile
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profile_image"
    }
}

struct Profile: Decodable {
    let medium: String
}
