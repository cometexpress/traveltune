//
//  FavoriteAudioGuideVCProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/16.
//

import Foundation

protocol FavoriteAudioGuideVCProtocol: AnyObject {
    func cellHeartButtonClicked(item: FavoriteStory)
    func didSelectItemAt(item: FavoriteStory)
}
