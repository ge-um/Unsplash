//
//  Mbti.swift
//  MVVMBasic
//
//  Created by 금가경 on 8/13/25.
//

import Foundation

enum Mbti: String, CaseIterable {
    case estj = "star.fill"
    case estp = "star"
    case esfj = "heart"
    case esfp = "heart.fill"
    case entj = "trash"
    case entp = "trash.fill"
    case enfj = "folder"
    case enfp = "folder.fill"
    case istj = "paperplane"
    case istp = "paperplane.fill"
    case isfj = "bookmark"
    case isfp = "bookmark.fill"
    case intj = "ruler"
    case intp = "ruler.fill"
    case infj = "circle.circle"
    case infp = "circle.circle.fill"
    
    var profileImage: String {
        return self.rawValue
    }
}

enum MbtiType { case ei, sn, tf, jp }
