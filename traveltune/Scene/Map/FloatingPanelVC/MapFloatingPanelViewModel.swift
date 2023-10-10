//
//  MapFloatingPanelViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/11.
//

import Foundation

final class MapFloatingPanelViewModel: BaseViewModel {
    
    enum MapFloatingPaneUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case error(msg: String)
    }
    
    private var travelSpotRepository: TravelSpotRepository
    private var storyRepository: StoryRepository
    var regionType: RegionType
    
    init(
        regionType: RegionType,
        travelSpotRepository: TravelSpotRepository,
        storyRepository: StoryRepository
    ) {
        self.regionType = regionType
        self.travelSpotRepository = travelSpotRepository
        self.storyRepository = storyRepository
    }
    
    var state: Observable<MapFloatingPaneUIState<[MapSpotItem]>> = Observable(.initValue)
    
    // 1. 관광지 지역별로 검색
    // 2. 해당 관광지 id 로 이야기 리스트 조회
    private var travelSpots: [TravelSpotItem] = []
    
    private var saveMapSpotItems: [MapSpotItem] = []
    
    func fetchMapSpotItems() {
        travelSpotRepository.requestTravelSpotsByLocation(
            page: 1,
            numOfRows: 50,
            mapX: String(regionType.longitude),
            mapY: String(regionType.latitude),
            radius: "15000"
        ) { [weak self] response in
            switch response {
            case .success(let success):
                let travelSpots = success.response.body.items.item
                
                let dispatchGroup = DispatchGroup()
                travelSpots.forEach { spotItem in
                    self?.basedStory(dispatchGroup: dispatchGroup, item: spotItem)
                }
                
                dispatchGroup.notify(queue: .main) { [weak self] in
                    guard let self else {
                        self?.state.value = .error(msg: "오류")
                        return
                    }
                    self.state.value = .success(data: self.saveMapSpotItems)
                }
                
            case .failure(let failure):
                self?.state.value = .error(msg: failure.localizedDescription)
            }
        }
    }
    
    private func basedStory(dispatchGroup: DispatchGroup, item: TravelSpotItem) {
        dispatchGroup.enter()
        storyRepository.requestBasedStory(item: item) { [weak self] response in
            switch response {
            case .success(let success):
                let stories = success.response.body.items.item
                self?.saveMapSpotItems.append(MapSpotItem(travelSpot: item, stories: stories))
            case .failure:
                print("값 추가 오류")
                self?.saveMapSpotItems.append(MapSpotItem(travelSpot: item, stories: []))
            }
            dispatchGroup.leave()
        }
    }
}
