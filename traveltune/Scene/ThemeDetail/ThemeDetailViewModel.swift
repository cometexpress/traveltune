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
    
    func favoriteStoryObserve() {
        guard let tasks = localFavoriteStoryRepository.fetch() else { return }
        notificationToken = tasks.observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial:
                print("initial")
                self.stories.value.forEach { item in
                    var copyItem = copy(item) { $0.isFavorite = self.checkFavoriteStory(item: item) }
                }
            case .update(_, let deletions, let insertions, let modifications):
                print("deletions = \(deletions)")
                print("insertions = \(insertions)")
                print("modifications = \(modifications)")
                
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
    
    private func checkFavoriteStory(item: StoryItem) -> Bool {
        let item = localFavoriteStoryRepository.fetchFilter {
            ($0.tid == item.tid) && ($0.tlid == item.tlid) && ($0.stid == item.stid) && ($0.stlid == item.stlid) && ($0.searchKeyword == item.searchKeyword)
        }?.first
        guard let _ = item else {
            return false
        }
        return true
    }
}
