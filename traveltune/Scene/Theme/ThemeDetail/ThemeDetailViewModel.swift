//
//  ThemeDetailViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/30.
//

import Foundation
import RealmSwift

/**
 < 테마 이야기 가져오는 법 - 최초 입장시에만 호출 >
 
 A. 관광지 키워드에서 검색 후 해당 아이디로 이야기 기본정보 목록 조회 api 호출
    1. 로컬에 저장되어 있는 관광지 list 의 테마카테고리 or 제목에 키워드가 있는 아이템을 키워드Array 에 추가
    2. 키워드 Array 아이템들을 For 문 돌면서 이야기 기본정보 목록 api 호출
    3. audioURL 이 있는 아이템만 로컬 테마이야기에 저장
 
 B. [A] 방법으로 했을 때 saveStories 가 Empty 라면 실행
    1. 이야기 키워드 검색 조회 api 호출
 */
final class ThemeDetailViewModel: BaseViewModel {
    
    enum ThemeDetailUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case singleDataError
        case localDataLoadError
        case error(msg: String)
    }
    
    private var localTravelSpotRepository: LocalTravelSpotRepository
    private var localThemeStoryRepository: LocalThemeStoryRepository
    private var localFavoriteStoryRepository: LocalFavoriteStoryRepository
    private var storyRepository: StoryRepository
    
    init(
        localTravelSpotRepository: LocalTravelSpotRepository,
        localThemeStoryRepository: LocalThemeStoryRepository,
        localFavoriteStoryRepository: LocalFavoriteStoryRepository,
        storyRepository: StoryRepository) {
            self.localTravelSpotRepository = localTravelSpotRepository
            self.localThemeStoryRepository = localThemeStoryRepository
            self.localFavoriteStoryRepository = localFavoriteStoryRepository
            self.storyRepository = storyRepository
        }
    
    private var saveStories: [StoryItem] = []
    
    var state: MyObservable<ThemeDetailUIState<[StoryItem]>> = MyObservable(.initValue)
    
    private let storyGroup = DispatchGroup()
    
    private var notificationToken: NotificationToken?
    
    deinit {
        notificationToken?.invalidate()
    }
    
    private func updateStories(searchKeyword: String) {
    
        self.state.value = .loading
        let localThemeSpots = localTravelSpotRepository.fetch()?
            .filter("themeCategory CONTAINS '\(searchKeyword)' OR title CONTAINS '\(searchKeyword)'")
        
        guard let localThemeSpots else {
            self.state.value = .localDataLoadError
            return
        }
        
        localThemeSpots.forEach { localItem in
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
                    // 못가져온 아이템 이야기가 있을 때 - 오류가 발생했어요
                    self.state.value = .singleDataError
                }
                self.storyGroup.leave()
            }
        }
        storyGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            if self.saveStories.isEmpty {
                // [B] 방법으로 호출
                print("저장된 한강이 없당깨")
                self.searchStories(page: 1, keyword: searchKeyword)
            } else {
                self.favoriteStoryObserve()
                self.localThemeStoryRepository.createAll(self.saveStories) {
                    // 저장 오류일 때 - 오류가 발생했어요
                    self.state.value = .error(msg: "로컬테마 저장하기 실패")
                }
            }
        }
    }
    
    private func searchStories(
        page: Int,
        keyword: String
    ){
        var pageNum = page
        storyRepository.requestSearchStory(page: pageNum, searchKeyword: keyword) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let success):
                var result = success.response.body.items.item
                result.removeAll(where: { $0.audioURL == "" } )
                result.enumerated().forEach { idx, item in
                    result[idx] = copy(item) { $0.searchKeyword = keyword }
                }
                self.saveStories.append(contentsOf: result)
                pageNum += 1
                self.searchStories(page: pageNum, keyword: keyword)

            case .failure:
                // 뒤에 더이상 값이 없는데 pageNum 을 올리면 빈값이 아니고 failure 을 던져준다.
                // 이때는 오류가 아니고 모든 데이터를 불러온 것
                // 데이터 저장 및 좋아요리스트 체크 옵저빙
                self.favoriteStoryObserve()
                self.localThemeStoryRepository.createAll(self.saveStories) {
                    // 저장 오류일 때 - 오류가 발생했어요
                    self.state.value = .error(msg: "로컬테마 저장하기 실패")
                }
            }
        }
    }
    
    private func checkExistAudioUrlStoryItem(item: StoryItem) -> StoryItem {
        let checkItem = localFavoriteStoryRepository.fetchFilter {
            ($0.tid == item.tid) && ($0.tlid == item.tlid) && ($0.stid == item.stid) && ($0.stlid == item.stlid) && ($0.searchKeyword == item.searchKeyword)
        }?.first
        let target = copy(item){ $0.isFavorite = checkItem == nil ? false : true }
        return target
    }
    
    func fetchThemeStoriesData(keyword: String) {
        let localStories = localThemeStoryRepository.fetchFilter {
            $0.searchKeyword.equals(keyword)
        }?.sorted(byKeyPath: "imageURL", ascending: false)
        
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
                let list = self.saveStories.map(checkFavoriteStory(item:)).sorted(by: {$0.imageURL > $1.imageURL})
                self.state.value = .success(data: list)
            case .update(_, let deletions, let insertions, let modifications):
                let list = self.saveStories.map(checkFavoriteStory(item:)).sorted(by: {$0.imageURL > $1.imageURL})
                self.state.value = .success(data: list)
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
