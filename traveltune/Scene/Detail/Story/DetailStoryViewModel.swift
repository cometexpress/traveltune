//
//  DetailStoryViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/09.
//

import Foundation
import RealmSwift

final class DetailStoryViewModel: BaseViewModel {
    
    enum DetailStoryUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case error(msg: String)
    }
    
    var detailStory: MyObservable<StoryItem?> = MyObservable(nil)
    var likeStatus: MyObservable<Bool> = MyObservable(false)
    
    private var storyRepository: StoryRepository
    private var localFavoriteStoryRepository: LocalFavoriteStoryRepository
    
    init(storyRepository: StoryRepository, localFavoriteStoryRepository: LocalFavoriteStoryRepository) {
        self.storyRepository = storyRepository
        self.localFavoriteStoryRepository = localFavoriteStoryRepository
    }
    
    private var notificationToken: NotificationToken?
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func favoriteStoryObserve() {
        guard let tasks = localFavoriteStoryRepository.fetch() else { return }
        notificationToken = tasks.observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial:
                print("좋아요한지 체크 - init")
                if let story = self.detailStory.value {
                    self.likeStatus.value = self.checkFavoriteStory(item: story)
                }
            case .update(_, let deletions, let insertions, let modifications):
                if let story = self.detailStory.value {
                    self.likeStatus.value = self.checkFavoriteStory(item: story)
                }
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addFavoriteStory() {
        guard let item = detailStory.value else { return }
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
    
    func deleteFavoriteStory() {
        guard let item = detailStory.value else { return }
        let checkItem = localFavoriteStoryRepository.fetch()?.filter(
            "tid == '\(item.tid)' AND tlid == '\(item.tlid)' AND stid == '\(item.stid)' AND stlid == '\(item.stlid)' AND searchKeyword == '\(item.searchKeyword)'"
        ).first
        if let checkItem {
            localFavoriteStoryRepository.delete(checkItem) {
                print(#function, " 삭제 실패")
            }
        }
    }
    
    private func checkFavoriteStory(item: StoryItem) -> Bool {
        let checkItem = localFavoriteStoryRepository.fetchFilter {
            ($0.tid == item.tid) && ($0.tlid == item.tlid) && ($0.stid == item.stid) && ($0.stlid == item.stlid) && ($0.langCode == item.langCode)
        }?.first
        return checkItem == nil ? false : true
    }
}
