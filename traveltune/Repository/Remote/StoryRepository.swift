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
    
}
