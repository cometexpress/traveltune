//
//  SearchController.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/03.
//

import Foundation

class SearchController {
    
    static let sectionHeaderElementKind = "search-section-header-element-kind"

    struct RecommendItem: Hashable {
        let title: String
        private let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    struct RecentSearchItem: Hashable {
        let keyword: String
        private let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
}
