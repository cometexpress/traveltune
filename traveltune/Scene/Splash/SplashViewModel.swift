//
//  SplashViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import Foundation

final class SplashViewModel {
    
    private let remoteTravelSpotRepository = RemoteTravelSpotRepository()
    private let localTravelSpotRepository = LocalTravelSpotRepository()
    
    private var page = 1
    private var totalCount = 0
    private var baseTravelSpots = [TravelSpotItem]()
    
    func updateTravelSpots(language: Network.LangCode, errorHandler: @escaping () -> Void) {
        remoteTravelSpotRepository.requestTravelSpots(page: page, language: language) { [weak self] response in
            guard let self else {
                print("self error")
                errorHandler()
                return
            }
            
            switch response {
            case .success(let success):
                let result = success.response
                if self.page == 1 {
                    self.totalCount = result.body.totalCount
                }
  
                self.baseTravelSpots.append(contentsOf: result.body.items.item)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    let travelSpotsCnt = self.baseTravelSpots.count
                    if travelSpotsCnt < self.totalCount {
                        self.page += 1
                        self.updateTravelSpots(language: language) {
                            errorHandler()
                        }
                    } else {
                        print("언어타입 - [\(language.rawValue)] / 총 갯수", self.baseTravelSpots.count)
                        self.saveTravelSpots(travelSpots: self.baseTravelSpots) {
                            errorHandler()
                        }
                    }
                }
                
            case .failure(let failure):
                print(failure.localizedDescription)
                errorHandler()
            }
        }
    }
    
    private func saveTravelSpots(travelSpots: [TravelSpotItem], errorHandler: () -> Void) {
        localTravelSpotRepository.createAll(travelSpots) {
            errorHandler()
        }
    }
}
