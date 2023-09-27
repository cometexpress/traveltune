//
//  Network.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/23.
//

import Foundation
import Alamofire
import OSLog

final class Network {
    static let shared = Network()
    private init() { }
    
    func request<T: Decodable>(
        api: Router,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        AF.request(api, interceptor: BaseRequestInterceptor()).responseDecodable(of: T.self) { response in
            var result = ""
            switch response.result {
            case .success(let data):
                result = "성공"
                completion(.success(data))
            case .failure(let error):
                result = "실패"
                completion(.failure(error))
            }
            print("========= \(response.request?.url) - \(result) =========")
            
        }
        
    }
}
