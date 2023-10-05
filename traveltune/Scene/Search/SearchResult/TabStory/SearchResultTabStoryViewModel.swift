//
//  SearchResultTabStoryViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/05.
//

import Foundation

final class SearchResultTabStoryViewModel: BaseViewModel {
    
    var keyword: String?
    private var storyRepository: StoryRepository?
    
    convenience init(keyword: String?, storyRepository: StoryRepository) {
        self.init()
        self.storyRepository = storyRepository
        self.keyword = keyword
    }
}
