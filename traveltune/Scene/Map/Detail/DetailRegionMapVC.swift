//
//  DetailRegionMapVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import UIKit
import CoreLocation

final class DetailRegionMapVC: BaseViewController<DetailRegionMapView, DetailRegionMapViewModel> {
    
    deinit {
        LocationManager.shared.stopUpdating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
        
        // 위치 권한 상태값 확인
        LocationManager.shared.locationAuthorizationStatus.bind { [weak self] authrizationStatus in
            switch authrizationStatus {
            case .initAuth: Void()
            case .none: Void()
            case .notDetermined:
                LocationManager.shared.requestAuthorization()
            case .denied:
                // iOS 설정으로 보내라는 alert 띄우기
                self?.showLocationSettingAlert()
            case .authorized:
                // didUpDateLocationer
                LocationManager.shared.startUpdating()
                self?.mainView.mapView.setUserTrackingMode(.follow, animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = Strings.TabMap.detailTitle
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
        
        mainView.detailRegionMapViewProtocol = self
        
        // 지역변경 피커뷰 감지
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(regionChangeObserver),
            name: .regionChange,
            object: nil
        )
    }
    
    func bindViewModel() {
        mainView.updateButtonTitle(title: viewModel?.regionType?.name ?? "")
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func regionChangeObserver(notification: NSNotification) {
        if let region = notification.userInfo?["region"] as? String {
            mainView.updateButtonTitle(title: region)
            // TODO: 지역 변경되었을 때 api 통신하기
        }
    }
    
    // GPS, 위치권한 획득 확인
    private func checkAvailableCurrentLocation() {
        LocationManager.shared.requestAuthorization()
        LocationManager.shared.deviceGpsStatus { [weak self] gps, authStatus in
            switch gps {
            case .on:
                if let authStatus {
                    LocationManager.shared.checkCurrentLocationAuthorization(status: authStatus)
                }
            case .off:
                self?.showLocationSettingAlert()
            }
        }
    }
    
    private func showLocationSettingAlert() {
        print(UIApplication.openSettingsURLString)
        showAlert(
            title: Strings.Common.locationServices,
            msg: Strings.Common.locationServicesGuide,
            ok: Strings.Common.move,
            no: Strings.Common.cancel) { _ in
                if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSetting)
                }
            }
    }
}

extension DetailRegionMapVC: DetailRegionMapVCProtocol {
    
    func currentLocationClicked() {
        checkAvailableCurrentLocation()
    }
    
    func selectRegionButtonClicked(item: String) {
        let vc = CommonPickerVC()
        vc.items = RegionType.allCases.map { $0.name }
        vc.selectedItem = item
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}

extension DetailRegionMapVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DetailRegionMapVC: CLLocationManagerDelegate {
    // 5. 사용자의 위치를 성공적으로 가지고 온 경우
    // 한번만 실행되는 것이 아니라 위치가 계속 바뀌면 계속 호출됨 , iOS 위치 업데이트가 필요한 시점에 알아서 여러번 호출!!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function ,locations)
        //        if let coordinate = locations.last?.coordinate {
        //            print(coordinate)
        //            setRegionAndAnnotation(center: coordinate)
        //        }
        // 위치 업데이트 그만하고 싶을 때
        //        locationManager.stopUpdatingLocation()
    }
    
    // 6. 사용자의 위치를 못가지고 왔을 경우 (사용자의 권한거부시에도 호출 됨)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error.localizedDescription)
    }
    
    // 7. 사용자의 권한 상태가 바뀔 때를 얄려줌 (iOS 14 이상)
    // 거부했다가 설정에서 변경을 했거나 ,notDetermained 상태에서 허용을 했거나
    // 허용해서 위치를 가지고 오는 도중에 설정에서 거부를 하고 앱으로 다시 돌아올 때
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 어떤 권한인지는 모르고 권한이 바뀌는 것만 암,
        print(#function)
        checkAvailableCurrentLocation()
    }
}
