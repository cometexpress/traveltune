//
//  MapFloatingPanelViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/11.
//

import Foundation

final class MapFloatingPanelViewModel: BaseViewModel {
    
    private var travelSpotRepository: TravelSpotRepository
    private var storyRepository: StoryRepository
    
    init(
        travelSpotRepository: TravelSpotRepository,
        storyRepository: StoryRepository
    ) {
        self.travelSpotRepository = travelSpotRepository
        self.storyRepository = storyRepository
    }
    
}
