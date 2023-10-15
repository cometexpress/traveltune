//
//  SettingItem.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/15.
//

import Foundation

struct SettingItem {
    let title: String
    let rightTitle: String
}

enum SettingsType: CaseIterable, CustomStringConvertible {
    
    case audioGuide
    case notification
    case terms
    case etc
    
    var contents: [String] {
        switch self {
        case .audioGuide:
            [Strings.Setting.settingAudioGuideItem01]
        case .notification:
            [Strings.Setting.settingNotificationItem01]
        case .terms:
            [Strings.Setting.settingTermsItem01]
        case .etc:
            [
                Strings.Setting.settingEtcItem01,
                Strings.Setting.settingEtcItem02,
                Strings.Setting.settingEtcItem03
            ]
        }
    }
    
    var detailContents: [String] {
        switch self {
        case .audioGuide:
            [""]
        case .notification:
            [""]
        case .terms:
            [""]
        case .etc:
            [
                "",
                "",
                "\(Constant.appVersion)"
            ]
        }
    }
    
    var description: String {
        switch self {
        case .audioGuide:
            Strings.Setting.settingHeaderAudioGuide
        case .notification:
            Strings.Setting.settingHeaderNotification
        case .terms:
            Strings.Setting.settingHeaderTerms
        case .etc:
            Strings.Setting.settingHeaderEtc
        }
    }
}
