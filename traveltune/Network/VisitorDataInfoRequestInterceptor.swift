//
//  VisitorDataInfoRequestInterceptor.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/28.
//

import Foundation
import Alamofire

final class VisitorDataInfoRequestInterceptor: RequestInterceptor {
    
    private lazy var defaultParameters = [
        "serviceKey": APIKey.dataKey,
        "MobileOS": "IOS",
        "MobileApp": "traveltune",
        "_type": "json"
    ]
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
        print("defaultParameters = ", defaultParameters)
        
        let encoding = URLEncodedFormParameterEncoder.default
        if let request = try? encoding.encode(defaultParameters, into: urlRequest) {
            urlRequest = request
        }
        
        completion(.success(urlRequest))
    }
    
}
