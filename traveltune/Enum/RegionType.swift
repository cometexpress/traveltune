//
//  RegionType.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit

enum RegionType: CaseIterable {
    case seoul
    case gyeonggi
    case incheon
    case gangwon
    case chungbuk
    case chungnam
    case sejong
    case daejeon
    case gyeongbuk
    case gyeongnam
    case daegu
    case ulsan
    case busan
    case jeonbuk
    case jeonnam
    case gwangju
    case jeju
    
    // 지역 검색할 때 사용할 좌표 저장
    var latitude: Double {
        switch self {
        case .seoul:
            37.541
        case .gyeonggi:
            0
        case .incheon:
            0
        case .gangwon:
            0
        case .chungbuk:
            0
        case .chungnam:
            0
        case .sejong:
            0
        case .daejeon:
            0
        case .gyeongbuk:
            0
        case .gyeongnam:
            0
        case .daegu:
            0
        case .ulsan:
            0
        case .busan:
            0
        case .jeonbuk:
            0
        case .jeonnam:
            0
        case .gwangju:
            0
        case .jeju:
            0
        }
    }
    
    var longitude: Double {
        switch self {
        case .seoul:
            126.986
        case .gyeonggi:
            0
        case .incheon:
            0
        case .gangwon:
            0
        case .chungbuk:
            0
        case .chungnam:
            0
        case .sejong:
            0
        case .daejeon:
            0
        case .gyeongbuk:
            0
        case .gyeongnam:
            0
        case .daegu:
            0
        case .ulsan:
            0
        case .busan:
            0
        case .jeonbuk:
            0
        case .jeonnam:
            0
        case .gwangju:
            0
        case .jeju:
            0
        }
    }
}
