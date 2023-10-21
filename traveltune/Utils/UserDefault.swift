//
//  UserDefault.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/28.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum UserDefaultsKey: String {
    case notificationStatus          // 노티피케이션 on, off
    case visitDate                  // 유저가 앱 방문한 날짜 - 관광지 정보 데이터 업데이트 할 때 사용 예정
    case updateKoreaTravelSpots     // 한국어버전 관광지 정보 오류 없이 잘가져왔는지 체크
    case updateEnglishTravelSpots   // 영어버전 관광지 정보 오류 없이 잘가져왔는지 체크
}

extension UserDefaults {
    @UserDefault(key: UserDefaultsKey.notificationStatus.rawValue, defaultValue: true)
    static var notificationStatus: Bool
    
    @UserDefault(key: UserDefaultsKey.visitDate.rawValue, defaultValue: "")
    static var visitDate: String
    
    @UserDefault(key: UserDefaultsKey.updateKoreaTravelSpots.rawValue, defaultValue: false)
    static var updateKoreaTravelSpots: Bool
    
    @UserDefault(key: UserDefaultsKey.updateEnglishTravelSpots.rawValue, defaultValue: false)
    static var updateEnglishTravelSpots: Bool
}
