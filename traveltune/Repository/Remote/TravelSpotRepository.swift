//
//  TravelSpotRepository.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import Foundation

final class TravelSpotRepository {
    
    private let network = Network.shared
    
    private let baseSpotsNumOfRows = "1000"
    private let searchSpotsNumOfRows = "20"
    
    func requestTravelSpots(
        page: Int,
        language: Network.LangCode? = nil,
        completion: @escaping (Result<ResponseTravelSpots, Error>) -> Void
    ) {
        network.request(
            api: .baseSpots(
                request: RequestTravelSpots(
                    numOfRows: baseSpotsNumOfRows,
                    pageNo: String(page)
                )
            ),
            type: ResponseTravelSpots.self,
            language: language) { response in
                completion(response)
            }
    }
    
    func requestSearchTravelSpots(
        page: Int,
        searchKeyword: String,
        completion: @escaping (Result<ResponseTravelSpots, Error>) -> Void
    ) {
        network.request(
            api: .searchSpots(request: RequestSearchTravelSpots(keyword: searchKeyword, numOfRows: searchSpotsNumOfRows)),
            type: ResponseTravelSpots.self) { response in
                completion(response)
            }
    }
}
