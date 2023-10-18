//
//  TravelBigDataRepository.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/18.
//

import Foundation

final class TravelBigDataRepository {
    
    private let network = Network.shared
    
    func requestTravelBigData(
        startDate: String,
        endDate: String,
        completion: @escaping (Result<ResponseCheckVisitorsInMetros, Error>) -> Void
    ) {
        network.requestVisitorInfo(
            api: .checkVisitorsInMetro(request: RequestCheckVisitorsInMetro(
                pageNo: "1",
                numOfRows: "50000",
                startYmd: startDate,
                endYmd: endDate)
            ), type: ResponseCheckVisitorsInMetros.self) { response in
                completion(response)
            }
    }
}
