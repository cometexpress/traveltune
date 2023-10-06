//
//  SearchResultViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/05.
//

import Foundation

final class SearchResultViewModel: BaseViewModel {

    private var localSearchKeywordRepository: LocalSearchKeywordRepository
    
    init(localSearchKeywordRepository: LocalSearchKeywordRepository) {
        self.localSearchKeywordRepository = localSearchKeywordRepository
    }
    
    func saveSearchKeyword(text: String) {
        localSearchKeywordRepository.create(SearchKeyword(text: text)) {
            print(#function, "검색단어 저장 실패")
        }
    }
}
