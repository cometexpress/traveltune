//
//  ThemeDetailViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/30.
//

import Foundation
import RealmSwift

final class ThemeDetailViewModel {
    
    private let localTravelSpotRepository = LocalTravelSpotRepository()
    private let localThemeStoryRepository = LocalThemeStoryRepository()
    private let localFavoriteStoryRepository = LocalFavoriteStoryRepository()
    
    private let storyRepository = StoryRepository()
    
    private var saveStories: [StoryItem] = []
    
    var stories: Observable<[StoryItem]> = Observable([])
    
    private let storyGroup = DispatchGroup()
    
    private var notificationToken: NotificationToken?
    
    deinit {
        notificationToken?.invalidate()
    }
    
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
                case .failure:
                    print("item.title = ",localItem.title, " 오류")
                }
                self.storyGroup.leave()
            }
        }
        storyGroup.notify(queue: .main) { [weak self] in
            self?.favoriteStoryObserve()
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
            print("데이터 기존꺼 불러오기")
            localStories.forEach { item in
                self.saveStories.append(item)
            }
            favoriteStoryObserve()
        }
    }
    
    private func favoriteStoryObserve() {
        guard let tasks = localFavoriteStoryRepository.fetch() else { return }
        notificationToken = tasks.observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial:
                print("좋아요한지 체크 - init")
                let list = self.saveStories.map(checkFavoriteStory(item:))
                self.stories.value.append(contentsOf: list)
            case .update(_, let deletions, let insertions, let modifications):
                self.stories.value.removeAll()
                let list = self.saveStories.map(checkFavoriteStory(item:))
                self.stories.value.append(contentsOf: list)
            case .error(let error):
                print("ERROR: \(error)")
            }
        }
    }
    
    func addFavoriteStory(item: StoryItem) {
        let favoriteItem =
        FavoriteStory(
            tid: item.tid,tlid: item.tlid, stid: item.stid, stlid: item.stlid,
            mapX: item.mapX, mapY: item.mapY, audioTitle: item.audioTitle, script: item.script,
            convertTime: item.convertTime, audioURL: item.audioURL, langCode: item.langCode,
            imageURL: item.imageURL, searchKeyword: item.searchKeyword
        )
        localFavoriteStoryRepository.create(favoriteItem) {
            print(#function, " 추가 실패")
        }
    }
    
    func deleteFavoriteStory(item: StoryItem) {
        let checkItem = localFavoriteStoryRepository.fetch()?.filter(
            "tid == '\(item.tid)' AND tlid == '\(item.tlid)' AND stid == '\(item.stid)' AND stlid == '\(item.stlid)' AND searchKeyword == '\(item.searchKeyword)'"
        ).first
        if let checkItem {
            localFavoriteStoryRepository.delete(checkItem) {
                print(#function, " 삭제 실패")
            }
        }
    }
    
    private func checkFavoriteStory(item: StoryItem) -> StoryItem {
        let checkItem = localFavoriteStoryRepository.fetchFilter {
            ($0.tid == item.tid) && ($0.tlid == item.tlid) && ($0.stid == item.stid) && ($0.stlid == item.stlid) && ($0.searchKeyword == item.searchKeyword)
        }?.first
        let target = copy(item){ $0.isFavorite = checkItem == nil ? false : true }
        return target
    }
}
