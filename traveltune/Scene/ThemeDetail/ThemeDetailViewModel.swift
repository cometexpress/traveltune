//
//  ThemeDetailViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/30.
//

import Foundation

final class ThemeDetailViewModel {
    
    private let localTravelSpotRepository = LocalTravelSpotRepository()
    private let storyRepository = StoryRepository()
    
    private var saveStories: [StoryItem] = []
    
    var stories: Observable<[StoryItem]> = Observable([])

    private let storyGroup = DispatchGroup()
    
    func fetchStories(searchKeyword: String) {
        let localThemeSpots = localTravelSpotRepository.fetchFilter {
            $0.title.contains(searchKeyword, options: .caseInsensitive)
        }

        localThemeSpots?.forEach { item in
            storyGroup.enter()
            storyRepository.requestBasedStory(item: item) { [weak self] response in
                switch response {
                case .success(let success):
                    let result = success.response.body.items.item
                    if let item = result.first {
                        if !item.audioURL.isEmpty {
                            self?.saveStories.append(item)
                        }
                    }
                case .failure(_):
                    print("item.title = ",item.title, " 오류")
                }
                self?.storyGroup.leave()
            }
        }
        
        storyGroup.notify(queue: .main) { [weak self] in
            print("모두 종료")
            self?.stories.value.append(contentsOf: self?.saveStories ?? [])
        }
    }
 
}
