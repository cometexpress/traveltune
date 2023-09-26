//
//  ThemeStory.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import UIKit

enum ThemeStory: CaseIterable {
    case tale               // 설화
    case history            // 한국 역사마을
    case market             // 전통시장
    case eastSea            // 동해
    case museum             // 박물관
    case temple             // 사찰
    
    var title: String {
        switch self {
        case .tale:
            Strings.ThemeStory.tale
        case .history:
            Strings.ThemeStory.history
        case .market:
            Strings.ThemeStory.market
        case .eastSea:
            Strings.ThemeStory.eastSea
        case .museum:
            Strings.ThemeStory.museum
        case .temple:
            Strings.ThemeStory.temple
        }
    }
    
    var content: String {
        switch self {
        case .tale:
            Strings.ThemeStory.taleContent
        case .history:
            Strings.ThemeStory.historyContent
        case .market:
            Strings.ThemeStory.marketContent
        case .eastSea:
            Strings.ThemeStory.eastSeaContent
        case .museum:
            Strings.ThemeStory.museumContent
        case .temple:
            Strings.ThemeStory.templeContent
        }
    }
    
    var thumbnail: UIImage {
        switch self {
        case .tale:
                .themeTale
        case .history:
                .themeHistory
        case .market:
                .themeMarket
        case .eastSea:
                .themeEastSea
        case .museum:
                .themeMuseum
        case .temple:
                .themeTemple
        }
    }
    
    var miniThumbnail: UIImage {
        switch self {
        case .tale:
                .themeMiniTale
        case .history:
                .themeMiniHistory
        case .market:
                .themeMiniMarket
        case .eastSea:
                .themeMiniEastSea
        case .museum:
                .themeMiniMuseum
        case .temple:
                .themeMiniTemple
        }
    }
}
