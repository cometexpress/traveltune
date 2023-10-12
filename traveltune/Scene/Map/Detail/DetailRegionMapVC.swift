//
//  DetailRegionMapVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import UIKit
import CoreLocation

final class DetailRegionMapVC: BaseViewController<DetailRegionMapView, DetailRegionMapViewModel> {
    
    private var naviTitle = ""
    
    /**
     1. 위치 시스템 권한 확인
     a. ON 상태, 위치 권한 요청 가능
     i. 권한 허용
     - 위치 데이터 접근 가능
     - 추후 권한을 거부할 경우에 다시 iOS 시스템 에서 설정 유도
     ii. 권한 거부
     - iOS 시스템 설정 유도
     b. OFF 상태, 위치 권한 요청 불가능
     - iOS 시스템 설정 유도
     */
    
//    lazy var locationManager: CLLocationManager = {
//            let manager = CLLocationManager()
//            manager.desiredAccuracy = kCLLocationAccuracyBest
//            manager.startUpdatingLocation() // startUpdate를 해야 didUpdateLocation 메서드가 호출됨.
//            manager.delegate = self
//            return manager
//        }()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
        
        /**
         내 위치 버튼 눌렀을 때 권한 체크 메서드 실행
         - 허용: 내 위치로 이동
         - 거부: 위치 권한 설정으로 이동할. 수 있도록 Alert 띄우기
         */
        locationManager.requestWhenInUseAuthorization()
        checkDeviceLocationAuthorization()
    }
    
    // 아이폰 GPS 기능 - ON or OFF 체크
    func checkDeviceLocationAuthorization() {
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            // locationServicesEnabled - 메인스레드에서 체크하면 안됨.
            // 아이폰 설정에서 위치서비스 확인 (gps설정 확인)
            if CLLocationManager.locationServicesEnabled() {
                let authorization = self.locationManager.authorizationStatus
                DispatchQueue.main.async {
                    print("authorization = \(authorization)")
                    self.checkCurrentLocationAuthorization(status: authorization)
                }

            } else {
                // GPS Off 상태
                DispatchQueue.main.async {
                    print("아이폰 위치서비스가 꺼져있으면 위치 권한요청을 할 수 없음")
                    self.showLocationSettingAlert()
                }
            }
        }
    }
    
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        print("stats =",status)
        switch status {
        case .notDetermined:
//            print("최초로 앱을 유저가 실행했을 때")
            print(#function, "\(status)")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest  // 위치 정확도 설정
            locationManager.requestWhenInUseAuthorization()  // 얼럿을 띄워주는 역할 - info.plist 에 알맞은 권한 명시해줘야 얼럿 동작
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
            // iOS 설정으로 보내라는 alert 띄우기
            showLocationSettingAlert()
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            //didUpDateLocationr
            locationManager.startUpdatingLocation()
        case .authorized:
            print("authorized")
        @unknown default:   // 위치 권한 종류가 추후에 더 생길 가능성을 대비해준 것
            print("default")
        }
    }
    
    func showLocationSettingAlert() {
        print(UIApplication.openSettingsURLString)
        
        let alert = UIAlertController(
            title: Strings.Common.locationServices,
            message: Strings.Common.locationServicesGuide,
            preferredStyle: .alert
        )
        
        // 설정에서 직접적으로 앱 설정 화면에 들어간 적이 없다면
        // 한번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이라서 앱 상세까지 못들어간다.
        // 유저가 들어간 적이 있다면 앱 상세까지 자동으로 이동됨.
        let goSetting = UIAlertAction(title: Strings.Common.move, style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: Strings.Common.cancel, style: .cancel)
        alert.addAction(goSetting)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = viewModel?.regionType?.name
    }
    
    func bindViewModel() {
        
    }
    
    func configureVC() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        navigationItem.backButtonDisplayMode = .minimal
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.background
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.txtPrimary,
            .font: UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)
        ]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailRegionMapVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DetailRegionMapVC: CLLocationManagerDelegate {
    
}
