//
//  URLSchemeManager.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/09.
//

import Foundation
import CoreLocation
import UIKit

enum SchemeType: CaseIterable {
    static var allCases: [SchemeType] = [
            .kakao(lat: 0, lng: 0),
            .naver(lat: 0, lng: 0, dname: ""),
            .tmap(lat: 0, lng: 0, rGoName: ""),
            .apple(arrivalPoint: "")
    ]
    
    case kakao(lat: Double, lng: Double)
    case naver(lat: Double, lng: Double, dname: String)
    case tmap(lat: Double, lng: Double, rGoName: String)
    case apple(arrivalPoint: String)
    
    var title: String {
        switch self {
        case .kakao: Strings.SchemeMapType.mapKakao
        case .naver: Strings.SchemeMapType.mapNaver
        case .tmap: Strings.SchemeMapType.mapTmap
        case .apple: Strings.SchemeMapType.mapApple
        }
    }
    
    var schemeURL: URL? {
        switch self {
        case .kakao(let lat, let lng):
            return URL(string: "kakaomap://route?ep=\(lat),\(lng)&by=CAR")
            
        case .naver(let lat, let lng, let dname):
            let urlStr = "nmap://route/car?dlat=\(lat)&dlng=\(lng)&dname=\(dname)&appname=com.comet.traveltune"
            guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
            return URL(string: encodedStr)
            
        case .tmap(let lat, let lng, let rGoName):
            let urlStr = "tmap://route?rGoName=\(rGoName)&rGoX=\(lng)&rGoY=\(lat)"
            guard let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
            return URL(string: encodedStr)
            
        case .apple(let arrivalPoint):
            print("arrivalPoint = \(arrivalPoint)")
            let urlStr = "maps://?daddr=\(arrivalPoint)&dirfgl=d"
            let encodedStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: encodedStr)
        }
    }
    
    var appStoreURL: URL? {
        switch self {
        case .kakao:
            URL(string: "itms-apps://itunes.apple.com/app/id304608425")
        case .naver:
            URL(string: "http://itunes.apple.com/app/id311867728?mt=8")
        case .tmap:
            URL(string: "http://itunes.apple.com/app/id431589174")
        case .apple:
            URL(string: "itms-apps://itunes.apple.com/app/id915056765")
        }
    }
}

final class URLSchemeManager {
    static let shared = URLSchemeManager()
    private init() { }
    
    func showURLScemeMap(type: SchemeType) {
        guard let schemeURL = type.schemeURL, let appStoreURL = type.appStoreURL else { return }
        switch type {
        case .kakao:
            let urlString = "kakaomap://open"
            if let appUrl = URL(string: urlString) { // 카카오맵 앱이 존재한다면,
                if UIApplication.shared.canOpenURL(appUrl) {
                    UIApplication.shared.open(schemeURL)
                } else {
                    // 카카오맵 앱이 없다면,
                    // 카카오맵 앱 설치 앱스토어로 이동
                    UIApplication.shared.open(appStoreURL)
                }
            }
        case .naver:
            if UIApplication.shared.canOpenURL(schemeURL) {
                UIApplication.shared.open(schemeURL)
            } else {
                // 네이버지도 앱이 없다면,
                // 네이버지도 앱 설치 앱스토어로 이동
                UIApplication.shared.open(appStoreURL)
            }
        case .tmap:
            if UIApplication.shared.canOpenURL(schemeURL) {
                UIApplication.shared.open(schemeURL)
            } else {
                // tmap 앱이 없다면,
                // tmap 설치 앱스토어로 이동
                UIApplication.shared.open(appStoreURL)
            }
        case .apple:
            if UIApplication.shared.canOpenURL(schemeURL) {
                UIApplication.shared.open(schemeURL)
            } else {
                // 애플 지도 앱이 없다면,
                // 애플지도 설치 앱스토어로 이동
                UIApplication.shared.open(appStoreURL)
            }
        }
    }
    
    func convertCoordnatesToAddress(lat: Double, lng: Double, completionHandler: @escaping (String) -> Void){
        let findLocation = CLLocation(latitude: lat, longitude: lng)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            guard let addr = placemarks else {
                return completionHandler("")
            }
            let name = addr.last?.name ?? ""
            return completionHandler(name)
        })
    }
}
