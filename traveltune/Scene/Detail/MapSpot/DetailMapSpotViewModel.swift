//
//  DetailMapSpotViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/11.
//

import Foundation
import RealmSwift

final class DetailMapSpotViewModel: BaseViewModel {
    
    enum DetailMapSpotUIState {
        case initValue
        case likeUpdateSuccess
        case error(msg: String)
    }
    
    var mapSpotItem: MapSpotItem?
    
    private var localFavoriteStoryRepository: LocalFavoriteStoryRepository
    
    init(localFavoriteStoryRepository: LocalFavoriteStoryRepository) {
        self.localFavoriteStoryRepository = localFavoriteStoryRepository
    }
    
    var state: MyObservable<DetailMapSpotUIState> = MyObservable(.initValue)
    
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
                let stories = self.mapSpotItem?.stories.map(checkFavoriteStory(item:)).sorted(by: {$0.imageURL > $1.imageURL})
                if let stories {
                    mapSpotItem?.stories = stories
                }
                self.state.value = .likeUpdateSuccess
            case .update(_, let deletions, let insertions, let modifications):
                let stories = self.mapSpotItem?.stories.map(checkFavoriteStory(item:)).sorted(by: {$0.imageURL > $1.imageURL})
                if let stories {
                    mapSpotItem?.stories = stories
                }
                self.state.value = .likeUpdateSuccess
            case .error(let error):
                self.state.value = .error(msg: error.localizedDescription)
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
