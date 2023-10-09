//
//  Constant.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/28.
//

import Foundation

struct Constant {

    static let productName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    
    struct HeroID {
        static let themeThumnail = "themeThumnail"
        static let themeOpacity = "themeOpacity"
    }
    
    struct Fonts {
        static let logo = "Pavelt"
    }
    
}
