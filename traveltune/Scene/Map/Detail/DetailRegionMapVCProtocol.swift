//
//  DetailRegionMapVCProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import Foundation

protocol DetailRegionMapVCProtocol: AnyObject {
    func currentLocationClicked()
    func selectRegionButtonClicked(item: String)
    func didSelectItemAt(item: StoryItem)
}
