//
//  SearchResultTabTravelSpotViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/05.
//

import Foundation

final class SearchResultTabTravelSpotViewModel {
    
    var searchKeyword: String?
    
    init() { }
    
    convenience init(searchKeyword: String?) {
        self.init()
        self.searchKeyword = searchKeyword
    }
}
