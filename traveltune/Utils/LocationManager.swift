//
//  LocationManager.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import CoreLocation
import Foundation

final class LocationManager {
    static let shared = LocationManager()
    private init() {}
    
    var locationManager: CLLocationManager {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }
    
    enum DeviceGPS {
        case on, off
    }
    
    enum LocationAuthorizationStatus {
        case initAuth, none, notDetermined, denied, authorized
    }
    
    var locationAuthorizationStatus: Observable<LocationAuthorizationStatus> = Observable(.initAuth)
        
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    func deviceGpsStatus(completion: @escaping (DeviceGPS, CLAuthorizationStatus?) -> ()) {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    completion(DeviceGPS.on, authorization)
                }
                
            } else {
                print("아이폰 위치서비스가 꺼져있으면 위치 권한요청을 할 수 없음")
                DispatchQueue.main.async {
                    completion(DeviceGPS.off, nil)
                }
            }
        }
    }
    
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("최초로 앱을 유저가 실행했을 때")
            locationAuthorizationStatus.value = .notDetermined
        case .restricted:
            print("restricted")
            locationAuthorizationStatus.value = .none
        case .denied:
            print("denied")
            locationAuthorizationStatus.value = .denied
        case .authorizedAlways:
            print("authorizedAlways")
            locationAuthorizationStatus.value = .authorized
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            locationAuthorizationStatus.value = .authorized
        case .authorized:
            print("authorized")
            locationAuthorizationStatus.value = .authorized
        @unknown default:   // 위치 권한 종류가 추후에 더 생길 가능성을 대비해준 것
            locationAuthorizationStatus.value = .none
        }
    }
}
