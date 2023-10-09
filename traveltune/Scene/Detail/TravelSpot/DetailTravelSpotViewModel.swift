//
//  DetailTravelSpotViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/08.
//

import Foundation

final class DetailTravelSpotViewModel: BaseViewModel {
    
    enum DetailSpotUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case error(msg: String)
    }
    
    var detailTravelSpot: Observable<TravelSpotItem?> = Observable(nil)
    
    private var travelSportRepository: TravelSpotRepository
    
    init(travelSportRepository: TravelSpotRepository) {
        self.travelSportRepository = travelSportRepository
    }
    
    var state: Observable<DetailSpotUIState<[TravelSpotItem]>> = Observable(.initValue)
    
    private let nearbyRadius = "5000"
    
    func searchNearbySpots(){
        guard let mapX = detailTravelSpot.value?.mapX, let mapY = detailTravelSpot.value?.mapY else { return }
        if mapX.isEmpty || mapY.isEmpty { return }
        
        print("mapX = \(mapX)")
        print("mapY = \(mapY)")
        
        state.value = .loading
        travelSportRepository.requestTravelSpotsByLocation(page: 1, mapX: mapX, mapY: mapY, radius: nearbyRadius) { response in
            switch response {
            case .success(let success):
                let result = success.response.body.items.item
                self.state.value = .success(data: result)
            case .failure(let failure):
                self.state.value = .error(msg: failure.localizedDescription)
            }
        }
    }
}
