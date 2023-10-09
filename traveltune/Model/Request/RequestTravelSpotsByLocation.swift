//
//  RequestTravelSpotsByLocation.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/09.
//

import Foundation

struct RequestTravelSpotsByLocation: Encodable {
    let pageNo: String
    let numOfRows: String
    let mapX: String    // ex) 126.61
    let mapY: String    // ex) 34.47
    let radius: String  // 거리 반경(단위 m) 최대 20000m (20km)
}
