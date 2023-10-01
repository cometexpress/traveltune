//
//  ThemeDetailViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/30.
//

import Foundation

final class ThemeDetailViewModel {
    
    private let localTravelSpotRepository = LocalTravelSpotRepository()
    private let localThemeStoryRepository = LocalThemeStoryRepository()
    private let localFavoriteStoryRepository = LocalFavoriteStoryRepository()
    
    private let storyRepository = StoryRepository()
    
    private var saveStories: [StoryItem] = []
    
    var stories: Observable<[StoryItem]> = Observable([])
    
    private let storyGroup = DispatchGroup()
    
    private func updateStories(searchKeyword: String) {
        let localThemeSpots = localTravelSpotRepository.fetch()?.filter("themeCategory CONTAINS '\(searchKeyword)' OR title CONTAINS '\(searchKeyword)'")
        localThemeSpots?.forEach { localItem in
            storyGroup.enter()
            storyRepository.requestBasedStory(item: localItem) { response in
                switch response {
                case .success(let success):
                    let result = success.response.body.items.item
                    if let resultItem = result.first {
                        if !resultItem.audioURL.isEmpty {
                            let item = copy(resultItem) { $0.searchKeyword = searchKeyword }
                            self.saveStories.append(item)
                        }
                    }
                case .failure(let _):
                    print("item.title = ",localItem.title, " 오류")
                }
                self.storyGroup.leave()
            }
        }
        storyGroup.notify(queue: .main) { [weak self] in
            self?.stories.value.append(contentsOf: self?.saveStories ?? [])
            
            self?.localThemeStoryRepository.createAll(self?.saveStories ?? []) {
                print("실패했을 때")
            }
        }
        
    }
    
    func fetchThemeStoriesData(keyword: String) {
        let localStories = localThemeStoryRepository.fetchFilter {
            $0.searchKeyword.equals(keyword)
        }?.sorted(byKeyPath: "_id")
        
        guard let localStories else { return }
        
        // 없을 때는 remote 레포에서 불러와야됨.
        if localStories.isEmpty {
            print("데이터 없어서 새로 불러오기")
            self.updateStories(searchKeyword: keyword)
        } else {
            localStories.forEach { item in
                self.saveStories.append(item)
            }
            print("데이터 기존꺼 불러오기")
            stories.value = saveStories
        }
    }
    
    func addFavoriteStory(item: FavoriteStory, error: () -> Void) {
        localFavoriteStoryRepository.create(item) {
            error()
        }
    }
}
