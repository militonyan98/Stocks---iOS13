//
//  NewsStory.swift
//  Stocks
//
//  Created by Hermine M on 08/03/2022.
//

import Foundation

/// Represents news story
struct NewsStory: Codable {
    let category: String
    let datetime: TimeInterval
    let headline: String
    let image: String
    let related: String
    let source: String
    let summary: String
    let url: String

}
