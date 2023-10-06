//
//  SearchViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import Foundation
import RealmSwift

final class SearchViewModel: BaseViewModel {
    
    enum SearchUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case emptySearchText
        case existSearchText(String)
        case error(msg: String)
    }
    
    struct Words {
        var recommendWords: [SearchController.Item]? = nil
        var recentSearchKeywords: [SearchController.Item]? = nil
    }
    
    private var localSearchKeywordRepository: LocalSearchKeywordRepository
    
    init(localSearchKeywordRepository: LocalSearchKeywordRepository) {
        self.localSearchKeywordRepository = localSearchKeywordRepository
    }
    
    private var notificationToken: NotificationToken?
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private var words = Words()
    
    var state: Observable<SearchUIState<Words>> = Observable(.initValue)
    
    func fetchWords() {
        state.value = .loading
        let recommends = SearchRecommendWord.list.map { SearchController.Item(recommendItem: SearchController.RecommendItem(title: $0)) }
        words.recommendWords = recommends
        searchKeywordObserve()
    }
    
    func checkSearchText(searchText: String) {
//        state.value = .initValue
        if searchText.isEmpty {
            state.value = .emptySearchText
        } else {
            state.value = .existSearchText(searchText)
        }
    }
    
    func saveSearchKeyword(text: String) {
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
                words.recentSearchKeywords = fetchSearchKeyword()
                state.value = .success(data: words)
            case .update(_, let deletions, let insertions, let modifications):
                print("검색어 insert = \(insertions)")
                print("검색어 delete = \(deletions)")
                words.recentSearchKeywords = fetchSearchKeyword()
                state.value = .success(data: words)
            case .error(let error):
                print("ERROR: \(error.localizedDescription)")
                state.value = .error(msg: error.localizedDescription)
            }
        }
    }
    
}
