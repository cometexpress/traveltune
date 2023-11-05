//
//  SearchResultTabStoryViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/05.
//

import Foundation

final class SearchResultTabStoryViewModel: BaseViewModel {
    
    enum SearchResultTabStoryUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case error(msg: String)
    }
    
    var keyword: String?
    private var storyRepository: StoryRepository
    
    init(keyword: String?, storyRepository: StoryRepository) {
        self.keyword = keyword
        self.storyRepository = storyRepository
    }
    
    var totalPage = 0
    var isLoading = false
    
    var state: MyObservable<SearchResultTabStoryUIState<[StoryItem]>> = MyObservable(.initValue)
    
    func searchStories(
        page: Int
    ){
        guard let keyword else { return }
        state.value = .loading
        isLoading = true
        storyRepository.requestSearchStory(page: page, searchKeyword: keyword) { response in
            switch response {
            case .success(let success):
                if page == 1 {
                    let totalCount = Int(success.response.body.totalCount)
                    let remainder = totalCount % Network.numOfRows
                    
                    if remainder > 0 {
                        self.totalPage = (totalCount / Network.numOfRows) + 1
                    } else {
                        self.totalPage = (totalCount / Network.numOfRows)
                    }
                    print("이야기 전체페이지 = \(self.totalPage)")
                }
                let result = success.response.body.items.item
                self.state.value = .success(data: result)
            case .failure(let failure):
                self.state.value = .error(msg: failure.localizedDescription)
            }
            self.isLoading = false
        }
    }
}
