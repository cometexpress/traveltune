//
//  ResponseStory.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/29.
//

import Foundation
import RealmSwift

// MARK: - ResponseStory
struct ResponseStory: Decodable {
    let response: ResultStory
}

// MARK: - Response
struct ResultStory: Decodable {
    let body: ResultStoryBody
}

// MARK: - Body
struct ResultStoryBody: Decodable {
    let items: StoryItems
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct StoryItems: Decodable {
    let item: [StoryItem]
}

// MARK: - Item
final class StoryItem: Object, Decodable {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var tid = ""
    @objc dynamic var tlid = ""
    @objc dynamic var stid = ""
    @objc dynamic var stlid = ""
    @objc dynamic var title = ""
    @objc dynamic var mapX = ""
    @objc dynamic var mapY = ""
    @objc dynamic var audioTitle = ""
    @objc dynamic var script = ""
    @objc dynamic var playTime = ""
    @objc dynamic var audioURL = ""
    @objc dynamic var langCode = ""
    @objc dynamic var imageURL = ""
    @objc dynamic var createdtime = ""
    @objc dynamic var modifiedtime = ""
    @objc dynamic var searchKeyword = ""
    
    override class func primaryKey() -> String? {
        return "_id"
    }
    
    enum CodingKeys: String, CodingKey {
        case tid, tlid, stid, stlid, title, mapX, mapY, audioTitle, script, playTime
        case audioURL = "audioUrl"
        case langCode
        case imageURL = "imageUrl"
        case createdtime, modifiedtime
    }
}
