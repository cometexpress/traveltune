//
//  SearchController.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/03.
//

import Foundation
import RealmSwift

final class SearchKeyword: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var text: String
    @Persisted var date: Date
    
    convenience init(text: String) {
        self.init()
        self.text = text
        self.date = .now
    }
    
    override var hash: Int {
        return _id.hashValue
    }
    
    static func == (lhs: SearchKeyword, rhs: SearchKeyword) -> Bool {
        return lhs._id == rhs._id
    }
}

final class SearchController {
    
    static let sectionHeaderElementKind = "search-section-header-element-kind"

    enum Section: Int, CaseIterable {
        case recommend, recentSearchKeyword
        var description: String {
            switch self {
            case .recommend: return Strings.Common.recommendKeyword
            case .recentSearchKeyword: return Strings.Common.recentSearchKeyword
            }
        }
    }
    
    struct Item: Hashable {
        private let identifier = UUID()
        let sectionTitle: String?
        let recommendItem: RecommendItem?
        let recentSearchItem: SearchKeyword?
    
        init(sectionTitle: String? = nil, recommendItem: RecommendItem? = nil, recentSearchItem: SearchKeyword? = nil) {
            self.sectionTitle = sectionTitle
            self.recommendItem = recommendItem
            self.recentSearchItem = recentSearchItem
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    struct RecommendItem: Hashable {
        private let identifier = UUID()
        let title: String
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
//    struct RecentSearchItem: Hashable {
//        private let identifier = UUID()
//        let keyword: String
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(identifier)
//        }
//    }
    
    
    
    
//    struct SearchCollection: Hashable {
//        private let identifier = UUID()
//        let title: String?
//        let recommendItems: [RecommendItem]?
//        let recentSearchItems: [RecentSearchItem]?
//        
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(identifier)
//        }
//        
//        init(title: String? = nil, recommendItems: [RecommendItem]? = nil, recentSearchItems: [RecentSearchItem]? = nil) {
//            self.title = title
//            self.recommendItems = recommendItems
//            self.recentSearchItems = recentSearchItems
//        }
//    }
    
//    static var collections: [SearchCollection] {
//        return _collections
//    }
//    
//    init() {
//        generateCollections()
//    }
//    fileprivate static var _collections = [SearchCollection]()
}

//extension SearchController {
//    func generateCollections() {
//        SearchController._collections = [
//            SearchCollection(title: "추천 검색어", recommendItems: [], recentSearchItems: []),
//            SearchCollection(title: "최근 검색어", recommendItems: [], recentSearchItems: [])
//        ]
//    }
//}
