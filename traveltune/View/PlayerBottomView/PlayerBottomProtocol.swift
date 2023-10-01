//
//  PlayerBottomProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/01.
//

import Foundation

protocol PlayerBottomProtocol: AnyObject {
    func previousClicked()
    func nextClicked()
    func playAndPauseClicked()
    func thumbImageClicked()
}
