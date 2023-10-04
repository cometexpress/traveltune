//
//  SearchViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import Foundation
import RealmSwift

final class SearchViewModel {
    
    
    
    
//    struct Words {
//        var recommendWords: [String]? = nil
//        var recentSearchKeywords: [SearchKeyword]? = nil
//    }
    
    struct Words {
        var recommendWords: [SearchController.Item]? = nil
        var recentSearchKeywords: [SearchController.Item]? = nil
    }
    
    private let localSearchKeywordRepository = LocalSearchKeywordRepository()
    
    private var notificationToken: NotificationToken?
    
    deinit {
        notificationToken?.invalidate()
    }
    
    var words: Observable<Words> = Observable(Words())
    
    func fetchWords() {
        let recommends = SearchRecommendWord.list.map { SearchController.Item(recommendItem: SearchController.RecommendItem(title: $0)) }
        words.value.recommendWords = recommends
        searchKeywordObserve()
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
    
    private func fetchSearchKeyword() -> [SearchController.Item]? {
        let searchWords =  localSearchKeywordRepository.fetch()?.sorted(byKeyPath: "date").toArray()
        return searchWords?.map {
            SearchController.Item(recentSearchItem: SearchController.RecentSearchItem(id: String(describing: $0._id), keyword: $0.text))
        }
    }
    
    func deleteSearchKeyword(id: String) {
        guard let deleteItem = localSearchKeywordRepository.objectByPrimaryKey(primaryKey: id) else { return }
        localSearchKeywordRepository.delete(deleteItem) {
            print("\(id) 삭제 실패")
        }
    }
    
    private func searchKeywordObserve() {
        guard let tasks = localSearchKeywordRepository.fetch() else { return }
        notificationToken = tasks.observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial:
                print("검색어있는지 체크 - init")
                words.value.recentSearchKeywords = fetchSearchKeyword()
            case .update(_, let deletions, let insertions, let modifications):
                print("검색어 delete")
                words.value.recentSearchKeywords = fetchSearchKeyword()
            case .error(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
}
