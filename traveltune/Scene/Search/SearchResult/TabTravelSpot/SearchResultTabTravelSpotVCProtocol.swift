//
//  SearchResultTabTravelSpotVCProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/06.
//

import Foundation

protocol SearchResultTabTravelSpotVCProtocol: AnyObject {
    func didSelectItemAt(item: TravelSpotItem)
    func willDisplay(page: Int)
    func scrollBeginDragging()
}
