//
//  ResponseTravelSpots.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/23.
//

import Foundation

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
struct TravelSpotItem: Decodable {
    let tid, tlid: String
    let themeCategory: String
    let addr1: String
    let addr2, title, mapX, mapY: String
    let langCheck: String
    let langCode: String
    let imageURL: String
    let createdtime, modifiedtime: String
    
    enum CodingKeys: String, CodingKey {
        case tid, tlid, themeCategory, addr1, addr2, title, mapX, mapY, langCheck, langCode
        case imageURL = "imageUrl"
        case createdtime, modifiedtime
    }
}
