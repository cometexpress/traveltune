//
//  ThemeStory.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import UIKit

enum ThemeStory: CaseIterable {
    case cheonggyecheon      // 청계천
    case market             // 전통시장
    case history            // 한국 역사마을
    case museum             // 박물관
    case temple             // 사찰
    case bukchon            // 북촌골목여행
    
    var searchKeyword: String {
        switch self {
        case .cheonggyecheon:
            Strings.ThemeStory.cheonggyecheonSearchKeyword
        case .market:
            Strings.ThemeStory.marketSearchKeyword
        case .history:
            Strings.ThemeStory.historySearchKeyword
        case .museum:
            Strings.ThemeStory.museumSearchKeyword
        case .temple:
            Strings.ThemeStory.templeSearchKeyword
        case .bukchon:
            Strings.ThemeStory.bukchonSearchKeyword
        }
    }
    
    var title: String {
        switch self {
        case .cheonggyecheon:
            Strings.ThemeStory.cheonggyecheon
        case .market:
            Strings.ThemeStory.market
        case .history:
            Strings.ThemeStory.history
        case .museum:
            Strings.ThemeStory.museum
        case .temple:
            Strings.ThemeStory.temple
        case .bukchon:
            Strings.ThemeStory.bukchon
        }
    }
    
    var content: String {
        switch self {
        case .cheonggyecheon:
            Strings.ThemeStory.cheonggyecheonContent
        case .market:
            Strings.ThemeStory.marketContent
        case .history:
            Strings.ThemeStory.historyContent
        case .museum:
            Strings.ThemeStory.museumContent
        case .temple:
            Strings.ThemeStory.templeContent
        case .bukchon:
            Strings.ThemeStory.bukchonContent
        }
    }
    
    var thumbnail: UIImage {
        switch self {
        case .cheonggyecheon:
                .themeCheonggyecheon
        case .history:
                .themeHistory
        case .market:
                .themeMarket
        case .museum:
                .themeMuseum
        case .temple:
                .themeTemple
        case .bukchon:
                .themeBukchon
        }
    }
    
    var miniThumbnail: UIImage {
        switch self {
        case .cheonggyecheon:
                .themeMiniCheonggyecheon
        case .history:
                .themeMiniHistory
        case .market:
                .themeMiniMarket
        case .museum:
                .themeMiniMuseum
        case .temple:
                .themeMiniTemple
        case .bukchon:
                .themeMiniBukchon
        }
    }
}
