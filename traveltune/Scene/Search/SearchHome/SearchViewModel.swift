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
        var recentSearchKeywords: [SearchKeyword]? = nil
    }
    
    private let localSearchKeywordRepository = LocalSearchKeywordRepository()
    
    var words: Observable<Words> = Observable(Words())
    
    func fetchWords() {
        words.value.recommendWords = SearchRecommendWord.list
        words.value.recentSearchKeywords = fetchSearchKeyword()
    }
    
    enum SearchStatus {
        case initial, empty, exist(String)
    }
    
    var isExistSearchText: Observable<SearchStatus> = Observable(.initial)
    
    func checkSearchText(searchText: String) {
        if searchText.isEmpty {
            isExistSearchText.value = .empty
        } else {
            saveSearchKeyword(text: searchText)
            isExistSearchText.value = .exist(searchText)
        }
    }
    
    private func saveSearchKeyword(text: String) {
        localSearchKeywordRepository.create(SearchKeyword(text: text)) {
            print(#function, "검색단어 저장 실패")
        }
    }
    
    private func fetchSearchKeyword() -> [SearchKeyword]? {
        return localSearchKeywordRepository.fetch()?.sorted(byKeyPath: "date").toArray()
    }
    
}
