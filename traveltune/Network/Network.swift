//
//  Network.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/23.
//

import Foundation
import Alamofire

class Network {
    static let shared = Network()
    private init() { }
    
    func requestConvertible<T: Decodable>(
        api: Router,
        type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        AF.request(api)
            .validate(statusCode: 200...500)
            .responseDecodable(of: T.self) { response in
                print("============== 요청 URL ", response.request?.url, "=============")
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
