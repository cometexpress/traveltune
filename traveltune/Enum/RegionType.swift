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
    
    var name: String {
        switch self {
        case .seoul:
            Strings.Region.seoul
        case .gyeonggi:
            Strings.Region.gyeonggi
        case .incheon:
            Strings.Region.incheon
        case .gangwon:
            Strings.Region.gangwon
        case .chungbuk:
            Strings.Region.chungbuk
        case .chungnam:
            Strings.Region.chungnam
        case .sejong:
            Strings.Region.sejong
        case .daejeon:
            Strings.Region.daejeon
        case .gyeongbuk:
            Strings.Region.gyeongbuk
        case .gyeongnam:
            Strings.Region.gyeongnam
        case .daegu:
            Strings.Region.daegu
        case .ulsan:
            Strings.Region.ulsan
        case .busan:
            Strings.Region.busan
        case .jeonbuk:
            Strings.Region.jeonbuk
        case .jeonnam:
            Strings.Region.jeonnam
        case .gwangju:
            Strings.Region.gwangju
        case .jeju:
            Strings.Region.jeju
        }
    }
    
    var latitude: Double {
        switch self {
        case .seoul:
            37.5666612
        case .gyeonggi:
            37.2893525
        case .incheon:
            37.4562557
        case .gangwon:
            37.8853984
        case .chungbuk:
            36.6358093
        case .chungnam:
            36.6013022
        case .sejong:
            36.4799919
        case .daejeon:
            36.3504567
        case .gyeongbuk:
            36.5760207
        case .gyeongnam:
            35.2394594
        case .daegu:
            35.8715411
        case .ulsan:
            35.5396224
        case .busan:
            35.179665
        case .jeonbuk:
            35.8203799
        case .jeonnam:
            34.8162186
        case .gwangju:
            35.1599785
        case .jeju:
            33.499597
        }
    }
    
    var longitude: Double {
        switch self {
        case .seoul:
            126.9783785
        case .gyeonggi:
            127.0535312
        case .incheon:
            126.7052062
        case .gangwon:
            127.7297758
        case .chungbuk:
            127.4913338
        case .chungnam:
            126.6608855
        case .sejong:
            127.2890511
        case .daejeon:
            127.3848187
        case .gyeongbuk:
            128.5055956
        case .gyeongnam:
            128.6942885
        case .daegu:
            128.601505
        case .ulsan:
            129.3115276
        case .busan:
            129.0747635
        case .jeonbuk:
            127.1086669
        case .jeonnam:
            126.4629242
        case .gwangju:
            126.8513072
        case .jeju:
            126.531254
        }
    }
}
