//
//  SearchResponse.swift
//  Unsplash
//
//  Created by 금가경 on 8/16/25.
//

import Foundation

struct SearchResponse: Decodable {
    let results: [Search]
}

struct Search: Decodable {
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
    
    var postDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        guard let date = formatter.date(from: createdAt) else {
            return "Failed to convert date from isoString"
        }
        
        let format = Date.FormatStyle()
            .month(.wide)
            .day(.twoDigits)
            .year(.defaultDigits)
            .locale(Locale(identifier: "ko_KR"))
        
        return date.formatted(format) + "게시됨"
    }
    
    var size: String {
        return "\(width) x \(height)"
    }
    
    static let sample = SearchResponse(results: [Search(id: "", createdAt: "", width: 0, height: 0, urls: SearchURL(raw: "", small: ""), likes: 0, user: User(name: "", profileImage: Profile(medium: "")))])
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
