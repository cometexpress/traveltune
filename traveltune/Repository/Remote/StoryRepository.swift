//
//  StoryRepository.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/30.
//

import Foundation

final class StoryRepository {
    
    private let network = Network.shared
    
    func requestBasedStory(
        item: TravelSpotItem,
        completion: @escaping (Result<ResponseStory, Error>) -> Void
    ) {
        Network.shared.request(
            api: .baseStories(request: RequestStory(tid: item.tid, tlid: item.tlid)),
            type: ResponseStory.self) { response in
                completion(response)
            }
    }
    
    func requestSearchStory(
        page: Int,
        searchKeyword: String,
        completion: @escaping (Result<ResponseStory, Error>) -> Void
    ) {
        Network.shared.request(
            api: .searchStories(
                request: RequestSearchStory(
                    keyword: searchKeyword,
                    pageNo: String(page),
                    numOfRows: String(Network.numOfRows)
                )
            ),
            type: ResponseStory.self) { response in
                completion(response)
            }
    }
 
    func requestStoryByLocation(
        page: Int,
        numOfRows: Int? = nil,
        mapX: String,
        mapY: String,
        radius: String,
        completion: @escaping (Result<ResponseStory, Error>) -> Void
    ) {
        network.request(
            api: .locationStories(
                request: RequestStoryByLocation(
                    pageNo: String(page),
                    numOfRows: String(numOfRows ?? Network.numOfRows),
                    mapX: mapX,
                    mapY: mapY,
                    radius: radius)
            ),
            type: ResponseStory.self) { response in
                completion(response)
            }
    }
}
