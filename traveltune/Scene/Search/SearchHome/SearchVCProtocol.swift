//
//  SearchVCProtocol.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/03.
//

import Foundation

protocol SearchVCProtocol: AnyObject {
    func textfieldDoneClicked(searchText: String)
    func recommendWordClicked(searchText: String)
    func recentWordClicked(searchText: String)
    func deleteRecentWordClicked(item: SearchController.RecentSearchItem)
}
