//
//  DetailStoryViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/09.
//

import Foundation

final class DetailStoryViewModel: BaseViewModel {
    
    enum DetailStoryUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case error(msg: String)
    }
    
    var detailStory: Observable<StoryItem?> = Observable(nil)
    
    private var storyRepository: StoryRepository
    
    init(storyRepository: StoryRepository) {
        self.storyRepository = storyRepository
    }
    
}
