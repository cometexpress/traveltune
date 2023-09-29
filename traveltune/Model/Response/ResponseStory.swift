//
//  ResponseStory.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/29.
//

import Foundation


// MARK: - ResponseStory
struct ResponseStory: Codable {
    let response: ResultStory
}

// MARK: - Response
struct ResultStory: Codable {
    let body: ResultStoryBody
}

// MARK: - Body
struct ResultStoryBody: Codable {
    let items: StoryItems
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct StoryItems: Codable {
    let item: [StoryItem]
}

// MARK: - Item
struct StoryItem: Codable {
    let tid, tlid, stid, stlid: String
    let title, mapX, mapY, audioTitle: String
    let script, playTime, audioURL, langCode: String
    let imageURL, createdtime, modifiedtime: String
    
    enum CodingKeys: String, CodingKey {
        case tid, tlid, stid, stlid, title, mapX, mapY, audioTitle, script, playTime
        case audioURL = "audioUrl"
        case langCode
        case imageURL = "imageUrl"
        case createdtime, modifiedtime
    }
}
