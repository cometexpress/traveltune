//
//  RegionType.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit

enum RegionType:String, CaseIterable {

    case seoul = "11"
    case gyeonggi = "41"
    case incheon = "28"
    case gangwon = "42"
    case chungbuk = "43"
    case chungnam = "44"
    case sejong = "36"
    case daejeon = "30"
    case gyeongbuk = "47"
    case gyeongnam = "48"
    case daegu = "27"
    case ulsan = "31"
    case busan = "26"
    case jeonbuk = "45"
    case jeonnam = "46"
    case gwangju = "29"
    case jeju = "50"
    
    var name: String {
        switch self {
        case .seoul:
            Strings.Region.seoul.firstCharUppercased()
        case .gyeonggi:
            Strings.Region.gyeonggi.firstCharUppercased()
        case .incheon:
            Strings.Region.incheon.firstCharUppercased()
        case .gangwon:
            Strings.Region.gangwon.firstCharUppercased()
        case .chungbuk:
            Strings.Region.chungbuk.firstCharUppercased()
        case .chungnam:
            Strings.Region.chungnam.firstCharUppercased()
        case .sejong:
            Strings.Region.sejong.firstCharUppercased()
        case .daejeon:
            Strings.Region.daejeon.firstCharUppercased()
        case .gyeongbuk:
            Strings.Region.gyeongbuk.firstCharUppercased()
        case .gyeongnam:
            Strings.Region.gyeongnam.firstCharUppercased()
        case .daegu:
            Strings.Region.daegu.firstCharUppercased()
        case .ulsan:
            Strings.Region.ulsan.firstCharUppercased()
        case .busan:
            Strings.Region.busan.firstCharUppercased()
        case .jeonbuk:
            Strings.Region.jeonbuk.firstCharUppercased()
        case .jeonnam:
            Strings.Region.jeonnam.firstCharUppercased()
        case .gwangju:
            Strings.Region.gwangju.firstCharUppercased()
        case .jeju:
            Strings.Region.jeju.firstCharUppercased()
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
