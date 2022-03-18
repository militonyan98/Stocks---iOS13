//
//  SearchResponse.swift
//  Stocks
//
//  Created by Hermine M on 03/03/2022.
//

import Foundation

struct SearchResponse: Codable {
    let count: Int
    let result: [SearchResult]
}


struct SearchResult: Codable {
    let description: String
    let displaySymbol: String
    let symbol: String
    let type: String
}
