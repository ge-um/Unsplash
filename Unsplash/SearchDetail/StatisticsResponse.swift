//
//  StatisticsResponse.swift
//  Unsplash
//
//  Created by 금가경 on 8/17/25.
//

import Foundation

struct StatisticsResponse: Decodable {
    let id: String
    let downloads: StatisticsDetail
    let views: StatisticsDetail
    
    var formattedDownloads: String {
        return downloads.total.formatted(.number)
    }
    
    var formattedViews: String {
        return views.total.formatted(.number)
    }
}

struct StatisticsDetail: Decodable {
    let total: Int
    let historical: Historical
}

struct Historical: Decodable {
    let values: [HistoricalValue]
}

struct HistoricalValue: Decodable {
    let date: String
    let value: Int
}
