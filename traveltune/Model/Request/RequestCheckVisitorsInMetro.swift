//
//  RequestCheckVisitorsInMetro.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/25.
//

import Foundation

struct RequestCheckVisitorsInMetro: Encodable {
    let pageNo: String
    let numOfRows: String
    let startYmd: String
    let endYmd: String
}
