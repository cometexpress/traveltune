//
//  RequestTravelSpot.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/23.
//

import Foundation

struct RequestTravelSpots: Encodable {
    let serviceKey: String
    let MobileOS: String
    let MobileApp: String
    let _type: String
    let numOfRows: String
    let pageNo: String
    let langCode: String    
}
