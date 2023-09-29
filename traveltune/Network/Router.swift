//
//  Router.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/23.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case baseSpots(request: RequestTravelSpots)          // 관광지 기본 정보 목록 조회
    case locationSpots      // 관광지 위치 기반 목록 조회 - WGS84 좌표
    case searchSpots(request: RequestSearchTravelSpots)        // 관광지 키워드 검색 조회
    case baseStories(request: RequestStory)                 // 이야기 기본 정보 목록 조회
    case locationStories     // 이야기 위치 기반 목록 조회 - WGS84 좌표
    case searchStories      // 이야기 키워드 검색 조회
    
    case checkVisitorsInMetro(request: RequestCheckVisitorsInMetro)       // 광역 지차체 방문자 수 조회
    
    private var baseURL: URL {
        switch self {
        case .baseSpots,
                .locationSpots,
                .searchSpots,
                .baseStories,
                .locationStories,
                .searchStories:
            return URL(string: "https://apis.data.go.kr/B551011/Odii/")!
        case .checkVisitorsInMetro:
            return URL(string: "http://apis.data.go.kr/B551011/DataLabService/")!
        }
    }
    
    private var path: String {
        switch self {
        case .baseSpots:
            return "themeBasedList"
        case .locationSpots:
            return "themeLocationBasedList"
        case .searchSpots:
            return "themeSearchList"
        case .baseStories:
            return "storyBasedList"
        case .locationStories:
            return "storyLocationBasedList"
        case .searchStories:
            return "storySearchList"
        case .checkVisitorsInMetro:
            return "metcoRegnVisitrDDList"
        }
    }
    
    private var method: HTTPMethod {
        return .get
    }
    
    private var query: [String: String] {
        switch self {
        case .baseSpots(let request):
            return request.toEncodable
        case .locationSpots:
            return ["": ""]
        case .searchSpots(let request):
            return request.toEncodable
        case .baseStories(let request):
            return request.toEncodable
        case .locationStories:
            return ["": ""]
        case .searchStories:
            return ["": ""]
        case .checkVisitorsInMetro(let request):
            return request.toEncodable
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        return request
    }
    
}

