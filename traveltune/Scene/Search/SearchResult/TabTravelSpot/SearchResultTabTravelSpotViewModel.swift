//
//  SearchResultTabTravelSpotViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/05.
//

import Foundation

final class SearchResultTabTravelSpotViewModel: BaseViewModel {
    
    enum SearchResultTabSpotUIState<T> {
        case initValue
        case loading
        case success(data: T)
        case error(msg: String)
    }
    
    var keyword: String?
    private var travelSportRepository: TravelSpotRepository?

    convenience init(keyword: String?, travelSportRepository: TravelSpotRepository) {
        self.init()
        self.travelSportRepository = travelSportRepository
        self.keyword = keyword
    }
    
    var state: Observable<SearchResultTabSpotUIState<[TravelSpotItem]>> = Observable(.initValue)
    
    var totalPage = 0
    var isLoading = false
    
    func searchSpots(
        page: Int
    ){
        guard let travelSportRepository, let keyword else { return }
        state.value = .loading
        isLoading = true
        travelSportRepository.requestSearchTravelSpots(page: page, searchKeyword: keyword) { response in
            switch response {
            case .success(let success):
                if page == 1 {
                    let totalCount = Int(success.response.body.totalCount)
                    let remainder = totalCount % Network.numOfRows
                    
                    if remainder > 0 {
                        self.totalPage = (totalCount / Network.numOfRows) + 1
                    } else {
                        self.totalPage = (totalCount / Network.numOfRows)
                    }
                    print("전체페이지 = \(self.totalPage)")
                }
                
                let result = success.response.body.items.item
                
                self.state.value = .success(data: result)
                self.isLoading = false
            case .failure(let failure):
                self.state.value = .error(msg: failure.localizedDescription)
                self.isLoading = false
            }
        }
    }
}
