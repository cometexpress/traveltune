//
//  BaseRequestInterceptor.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/25.
//

import Foundation
import Alamofire

final class BaseRequestInterceptor: RequestInterceptor {
    
    private var defaultParameters = [
        "serviceKey": APIKey.dataKey,
        "MobileOS": "IOS",
        "MobileApp": "AppTest",
        "_type": "json"
    ]
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        let encoding = URLEncodedFormParameterEncoder.default
        if let request = try? encoding.encode(defaultParameters, into: urlRequest) {
            urlRequest = request
        }
        
        completion(.success(urlRequest))
    }
    
}
