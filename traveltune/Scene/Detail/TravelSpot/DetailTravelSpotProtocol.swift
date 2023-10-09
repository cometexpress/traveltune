//
//  DetailTravelSpotProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/08.
//

import Foundation

protocol DetailTravelSpotProtocol: AnyObject {
    func backButtonClicked()
    func didSelectItemAt(item: TravelSpotItem)
}
