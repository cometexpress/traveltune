//
//  BaseRequestInterceptor.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/25.
//

import Foundation
import Alamofire

final class BaseRequestInterceptor: RequestInterceptor {
    
    init(language: String?) {
        guard let language else {
            langCode = systemLangCode
            return
        }
        langCode = language
    }
    
    private var langCode = "ko"
    
    private lazy var defaultParameters = [
        "serviceKey": APIKey.dataKey,
        "MobileOS": "IOS",
        "MobileApp": "트래블튠",
        "_type": "json",
        "langCode": langCode
    ]
    
    private let systemLangCode = if #available(iOS 16.0, *) {
        Locale.current.language.languageCode?.identifier ?? "ko"
    } else {
        Locale.current.languageCode ?? "ko"
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        
//        print("defaultParameters = ", defaultParameters)
        
        let encoding = URLEncodedFormParameterEncoder.default
        if let request = try? encoding.encode(defaultParameters, into: urlRequest) {
            urlRequest = request
        }
        
        completion(.success(urlRequest))
    }
    
}
