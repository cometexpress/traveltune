//
//  FavoriteAudioGuideViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/16.
//

import Foundation
import RealmSwift

final class FavoriteAudioGuideViewModel: BaseViewModel {
    
    enum FavoriteAudioGuideUIState<T> {
        case initValue
        case success(data: T)
//        case sortUpdate(data: T)
        case deleteUpdate(data: T)
        case error(msg: String)
    }
    
    private var localFavoriteStoryRepository: LocalFavoriteStoryRepository
    
    init(localFavoriteStoryRepository: LocalFavoriteStoryRepository) {
        self.localFavoriteStoryRepository = localFavoriteStoryRepository
    }
    
    private var notificationToken: NotificationToken?
    
    deinit {
        notificationToken?.invalidate()
    }
    
    var state: Observable<FavoriteAudioGuideUIState<[FavoriteStory]>> = Observable(.initValue)
    
    func favoriteStoryObserve() {
        guard let tasks = localFavoriteStoryRepository.fetch() else { return }
        notificationToken = tasks.observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial:
                print("좋아요 리스트 - init")
                var favoriteStroies: [FavoriteStory] = []
                tasks.forEach { story in
                    favoriteStroies.append(story)
                }
                self.state.value = .success(data: favoriteStroies)

            case .update(_, let deletions, let insertions, let modifications):
                var favoriteStroies: [FavoriteStory] = []
                tasks.forEach { story in
                    favoriteStroies.append(story)
                }
                self.state.value = .deleteUpdate(data: favoriteStroies)

            case .error(let error): break
                self.state.value = .error(msg: error.localizedDescription)
            }
        }
    }
    
    func deleteFavoriteStory(item: FavoriteStory) {
        let checkItem = localFavoriteStoryRepository.fetch()?.filter(
            "tid == '\(item.tid)' AND tlid == '\(item.tlid)' AND stid == '\(item.stid)' AND stlid == '\(item.stlid)' AND searchKeyword == '\(item.searchKeyword)'"
        ).first
        if let checkItem {
            localFavoriteStoryRepository.delete(checkItem) {
                print(#function, " 삭제 실패")
            }
        }
    }
}
