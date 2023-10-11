//
//  DetailMapSpotVCProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/11.
//

import Foundation

protocol DetailMapSpotVCProtocol: AnyObject {
    func backClicked()
    func moveMapClicked()
    func cellHeartButtonClicked(item: StoryItem)
    func didSelectItemAt(item: StoryItem)
}
