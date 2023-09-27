//
//  ResponseTravelSpots.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/23.
//

import Foundation
import RealmSwift

// MARK: - TouristSpot
struct ResponseTravelSpots: Decodable {
    let response: ResultTravelSpot
}

// MARK: - Response
struct ResultTravelSpot: Decodable {
    let body: TravelSpotBody
}

// MARK: - Body
struct TravelSpotBody: Decodable {
    let items: TravelSpotItems
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct TravelSpotItems: Decodable {
    let item: [TravelSpotItem]
}

// MARK: - Item
final class TravelSpotItem: Object, Decodable {
    @objc dynamic var _id = ObjectId()
    @objc dynamic var tid = ""
    @objc dynamic var tlid = ""
    @objc dynamic var themeCategory = ""
    @objc dynamic var addr1 = ""
    @objc dynamic var addr2 = ""
    @objc dynamic var title = ""
    @objc dynamic var mapX = ""
    @objc dynamic var mapY = ""
    @objc dynamic var langCheck = ""
    @objc dynamic var langCode = ""
    @objc dynamic var imageURL = ""
    @objc dynamic var createdtime = ""
    @objc dynamic var modifiedtime = ""
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    enum CodingKeys: String, CodingKey {
        case tid, tlid, themeCategory, addr1, addr2, title, mapX, mapY, langCheck, langCode
        case imageURL = "imageUrl"
        case createdtime, modifiedtime
    }
}
