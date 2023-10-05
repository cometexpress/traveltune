//
//  SplashViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import Foundation

final class SplashViewModel {
    
    enum SplashUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case error(msg: String)
    }
    
    private let remoteTravelSpotRepository = TravelSpotRepository()
    private let localTravelSpotRepository = LocalTravelSpotRepository()
    
    private var koPage = 1
    private var koTotalCount = 0
    private var koTravelSpots = [TravelSpotItem]()
    
    private var enPage = 1
    private var enTotalCount = 0
    private var enTravelSpots = [TravelSpotItem]()
    
    private var baseTravelSpots = [TravelSpotItem]()
    
    var maximumDays = 14
    
    var isCompleteAllLanguageUpdateSpots: Observable<SplashUIState<Bool>> = Observable(.initValue)
    
    func updateAllLangTravelSpots() {
        requestGroup { group in
            updateKoTravelSpots(group: group) { UserDefaults.updateKoreaTravelSpots = false }
            updateEnTravelSpots(group: group) { UserDefaults.updateEnglishTravelSpots = false }
        } start: {
            print("시작한다잇")
            isCompleteAllLanguageUpdateSpots.value = .loading
        } notify: {
            print("종료됫다잇")
            UserDefaults.updateKoreaTravelSpots = true
            UserDefaults.updateEnglishTravelSpots = true
            self.baseTravelSpots.append(contentsOf: self.koTravelSpots)
            self.baseTravelSpots.append(contentsOf: self.enTravelSpots)
            self.saveTravelSpots()
        }
    }
    
    private func requestGroup(
        callRequest: (DispatchGroup) -> Void,
        start: () -> Void,
        notify: @escaping () -> Void
    ) {
        start()
        let group = DispatchGroup()
        callRequest(group)
        group.notify(queue: .main) {
            print("모두 종료")
            notify()
        }
    }
    
    // 한국어 관광지 정보 불러오기
    private func updateKoTravelSpots(group: DispatchGroup, errorHandler: @escaping () -> Void) {
        
        group.enter()
        let language = Network.LangCode.ko
        
        remoteTravelSpotRepository.requestTravelSpots(page: koPage, language: language) { [weak self] response in
            guard let self else {
                print("self error")
                errorHandler()
                group.leave()
                return
            }
            
            switch response {
            case .success(let success):
                let result = success.response
                if self.koPage == 1 {
                    self.koTotalCount = result.body.totalCount
                }
  
                self.koTravelSpots.append(contentsOf: result.body.items.item)
                
                let travelSpotsCnt = self.koTravelSpots.count
                if travelSpotsCnt < self.koTotalCount {
                    self.koPage += 1
                    self.updateKoTravelSpots(group: group) { errorHandler() }
                } else {
                    print("언어타입 - [\(language.rawValue)] / 총 갯수", self.koTravelSpots.count)
                }
                
            case .failure(let failure):
                print(failure.localizedDescription)
                errorHandler()
            }
            group.leave()
        }
    }
    
    // 영어 관광지 정보 불러오기
    private func updateEnTravelSpots(group: DispatchGroup, errorHandler: @escaping () -> Void) {
        
        group.enter()
        let language = Network.LangCode.en
        
        remoteTravelSpotRepository.requestTravelSpots(page: enPage, language: language) { [weak self] response in
            guard let self else {
                print("self error")
                errorHandler()
                group.leave()
                return
            }
            
            switch response {
            case .success(let success):
                let result = success.response
                if self.enPage == 1 {
                    self.enTotalCount = result.body.totalCount
                }
  
                self.enTravelSpots.append(contentsOf: result.body.items.item)
                
                let travelSpotsCnt = self.enTravelSpots.count
                if travelSpotsCnt < self.enTotalCount {
                    self.enPage += 1
                    self.updateEnTravelSpots(group: group) { errorHandler() }
                } else {
                    print("언어타입 - [\(language.rawValue)] / 총 갯수", self.enTravelSpots.count)
                }
                
            case .failure(let failure):
                print(failure.localizedDescription)
                errorHandler()
            }
            group.leave()
        }
    }
    
    // Realm 에 저장하기
    private func saveTravelSpots() {
        localTravelSpotRepository.createAll(baseTravelSpots) {
            isCompleteAllLanguageUpdateSpots.value = .success(data: true)
        }
    }
    
    func compareToDateTheDay(start: String, end: String) {
        let days = DateManager.shared.compareToDateByTheDay(start: start, end: end)
        if days <= maximumDays {
            isCompleteAllLanguageUpdateSpots.value = .success(data: true)
        } else {
            print("데이터 업데이트 필요")
            removeAllSpot { isSuccess in
                if isSuccess {
                    updateAllLangTravelSpots()
                } else {
                    isCompleteAllLanguageUpdateSpots.value = .error(msg: "데이터 업데이트를 위한 realm 기존 데이터 삭제 작업 실패")
                }
            }
        }
    }
    
    private func removeAllSpot(isSuccess: (Bool) -> Void) {
        localTravelSpotRepository.deleteAll { isComplete in
            isSuccess(isComplete)
        }
    }
}
