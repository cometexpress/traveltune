//
//  ResponseCheckVisitorsInMetro.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/25.
//

import Foundation

// MARK: - ResponseCheckVisitorsInMetros
struct ResponseCheckVisitorsInMetros: Codable {
    let response: ResultCheckVisitorsInMetro
}

// MARK: - Response
struct ResultCheckVisitorsInMetro: Codable {
    let body: CheckVisitorsInMetroBody
}

// MARK: - Body
struct CheckVisitorsInMetroBody: Codable {
    let items: CheckVisitorsInMetroItems
    let numOfRows, pageNo, totalCount: Int
}

// MARK: - Items
struct CheckVisitorsInMetroItems: Codable {
    let item: [CheckVisitorsInMetroItem]
}

// MARK: - Item
struct CheckVisitorsInMetroItem: Codable {
    let areaCode, areaNm, daywkDivCD: String
    let daywkDivNm: String
    let touDivCD: String
    let touDivNm: String
    let touNum, baseYmd: String

    enum CodingKeys: String, CodingKey {
        case areaCode, areaNm
        case daywkDivCD = "daywkDivCd"
        case daywkDivNm
        case touDivCD = "touDivCd"
        case touDivNm, touNum, baseYmd
    }
}

//enum DaywkDivNm: String, Codable {
//    case 목요일 = "목요일"
//}
//
//enum TouDivNm: String, Codable {
//    case 외국인C = "외국인(c)"
//    case 외지인B = "외지인(b)"
//    case 현지인A = "현지인(a)"
//}
//
//// MARK: - Header
//struct Header: Codable {
//    let resultCode, resultMsg: String
//}

