//
//  ThemeDetailVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit
import Hero

final class ThemeDetailVC: BaseViewController<ThemeDetailView> {
    
    var themeStory: ThemeStory?
    
    var remoteTravelSpotRepository = RemoteTravelSpotRepository()
    var localTravelSpotRepository = LocalTravelSpotRepository()
    
    private var dataIds: [RequestStory] = []
    private var stories: [StoryItem] = []
    
    override func configureVC() {
        mainView.themeDetailVCProtocol = self
        guard let themeStory else { return }
        print("현재 컨텐츠 정보 \(themeStory.title)")
        mainView.hero.modifiers = [.translate(y:100)]
        mainView.backgroundImageView.image = themeStory.thumbnail
        mainView.topTitleLabel.text = themeStory.title
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.mainView.collectionView.isHidden = false
        }
        
        // 관광지 테마 검색
        Network.shared.request(
            api: .searchSpots(request: RequestSearchTravelSpots(keyword: themeStory.searchKeyword, numOfRows: "1000")),
            type: ResponseTravelSpots.self) { response in
                switch response {
                case .success(let success):
                    print(success)
                    let result = success.response.body.items.item
                    result.forEach { item in
                        self.dataIds.append(RequestStory(tid: item.tid, tlid: item.tlid))
                    }
                    
                    // 데이터 아이디로 다시 이야기 기본정보 목록 조회하기
                    self.dataIds.forEach { item in
                        
                        // TODO: DispatchGroup 사용 필요할 듯
                        // TODO: 모든 데이터 받은 시점에 stories 데이터 갯수 찍어보기
                        Network.shared.request(
                            api: .baseStories(request: RequestStory(tid: item.tid, tlid: item.tlid)),
                            type: ResponseStory.self) { response in
                                switch response {
                                case .success(let success):
                                    let result = success.response.body.items.item
                                    
                                    result.forEach { item in
                                        self.stories.append(item)
                                        print("테마로 검색한 이야기 아이템 - ", item.title)
                                    }
                                    
                                case .failure(let failure):
                                    // TODO: 오류일 때 어떻게 처리할지
                                    print(failure)
                                }
                            }
                    }
                case .failure(let failure):
                    // TODO: 오류일 때 어떻게 처리할지
                    print(failure)
                }
            }
        
    }
    
}

extension ThemeDetailVC: ThemeDetailVCProtocol {
    
    func backButtonClicked() {
        mainView.topView.isHidden = true
        mainView.collectionView.isHidden = true
        dismiss(animated: true)
    }
    
    func infoButtonClicked() {
        print("상세 내용 보는 기능")
    }
    
    func previousButtonClicked() {
        print("이전으로 스킵")
    }
    
    func nextButtonClicked() {
        print("다음으로 스킵")
    }
    
    func playAndPauseButtonClicked() {
        print("재생 or 일시정지 클릭")
    }
    
}

