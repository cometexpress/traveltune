//
//  SearchViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import Foundation

final class SearchViewModel {
    
    struct Words {
        var recommendWords: [String]? = nil
        var recentSearchKeywords: [String]? = nil
    }
    
    let testRecentSearchKeywords = ["감자", "고구마", "설날", "고깃덩어리", "햄", "국자", "1텍스트","2텍스트", "3텍스트", "4텍스트", "wow???"]
    
    var words: Observable<Words> = Observable(Words())
    
    func fetchWords() {
        words.value.recommendWords = SearchRecommendWord.list
        words.value.recentSearchKeywords = testRecentSearchKeywords
    }
    
    enum SearchStatus {
        case initial, empty, exist(String)
    }
    
    var isExistSearchText: Observable<SearchStatus> = Observable(.initial)
    
    func checkSearchText(searchText: String) {
        if searchText.isEmpty {
            isExistSearchText.value = .empty
        } else {
            isExistSearchText.value = .exist(searchText)
        }
    }
    
}
