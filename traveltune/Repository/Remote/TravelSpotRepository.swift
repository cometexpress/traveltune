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
                    numOfRows: String(Network.numOfRowsByAllData),
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
            api: .searchSpots(
                request: RequestSearchTravelSpots(
                    keyword: searchKeyword,
                    pageNo: String(page),
                    numOfRows: String(Network.numOfRows)
                )
            ),
            type: ResponseTravelSpots.self) { response in
                completion(response)
            }
    }
    
    func requestTravelSpotsByLocation(
        page: Int,
        mapX: String,
        mapY: String,
        radius: String,
        completion: @escaping (Result<ResponseTravelSpots, Error>) -> Void
    ) {
        network.request(
            api: .locationSpots(
                request: RequestTravelSpotsByLocation(
                    pageNo: String(page),
                    numOfRows: String(Network.numOfRows),
                    mapX: mapX,
                    mapY: mapY,
                    radius: radius)
            ),
            type: ResponseTravelSpots.self) { response in
                completion(response)
            }
    }

}
