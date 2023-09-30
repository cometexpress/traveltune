//
//  TravelSpotRepository.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import Foundation

final class TravelSpotRepository {
    
    private let network = Network.shared
    
    func requestTravelSpots(
        page: Int,
        language: Network.LangCode? = nil,
        completion: @escaping (Result<ResponseTravelSpots, Error>) -> Void
    ) {
        network.request(
            api: .baseSpots(
                request: RequestTravelSpots(
                    numOfRows: "1000",
                    pageNo: String(page)
                )
            ),
            type: ResponseTravelSpots.self,
            language: language
        ) { response in
                completion(response)
            }
    }
    
}
