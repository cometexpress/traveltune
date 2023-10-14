//
//  DetailRegionMapVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import UIKit
import CoreLocation
import MapKit

final class DetailRegionMapVC: BaseViewController<DetailRegionMapView, DetailRegionMapViewModel> {
    
    deinit {
        LocationManager.shared.stopUpdating()
    }
    
    private var stories: [StoryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
                
        LocationManager.shared.startUpdating()
        LocationManager.shared.locationManager.delegate = self
        
        bindLocationAuthStatus()
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
        mainView.mapView.delegate = self
        
        // 지역변경 피커뷰 감지
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(regionChangeObserver),
            name: .regionChange,
            object: nil
        )
    }
    
    func bindViewModel() {
        guard let type = viewModel?.regionType else { return }
        mainView.updateButtonTitle(title: type.name)
        viewModel?.fetchStoryByLocation(lat: type.latitude, lng: type.longitude)
        
        viewModel?.state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initValue: Void()
            case .loading:
                LoadingIndicator.show()
            case .success(let data, let lat, let lng):
                data.forEach { item in
                    self.addMarker(story: item)
                }
                stories = data
                
                let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 100000, longitudinalMeters: 100000)
                self.mainView.mapView.setRegion(region, animated: true)
                
                // 모든 annotation 표시
//                self.mainView.mapView.showAnnotations(self.mainView.mapView.annotations, animated: true)
                
                LoadingIndicator.hide()
            case .error:
                self.showToast(msg: Strings.ErrorMsg.errorLoadingData)
                LoadingIndicator.hide()
            }
        }
    }
    
    // 위치 권한 상태값 확인
    private func bindLocationAuthStatus() {
        LocationManager.shared.locationAuthorizationStatus.bind { [weak self] authrizationStatus in
            guard let self else { return }
            switch authrizationStatus {
            case .initAuth: Void()
            case .none: Void()
            case .notDetermined:
                LocationManager.shared.requestAuthorization()
            case .denied:
                // iOS 설정으로 보내라는 alert 띄우기
                self.showLocationSettingAlert()
            case .authorized:
                // didUpDateLocationer
                DispatchQueue.main.async {
                    LocationManager.shared.startUpdating()
                    self.mainView.mapView.removeAnnotations(self.mainView.mapView.annotations)
//                    self.mainView.mapView.showsUserLocation = true
                    self.mainView.mapView.setUserTrackingMode(.follow, animated: true)
                    guard let userLocation = self.mainView.mapView.userLocation.location else {
                        print("유저 위치 없음")
                        self.showToast(msg: Strings.ErrorMsg.errorLocation)
                        return
                    }
                    self.viewModel?.fetchStoryByLocation(lat: userLocation.coordinate.latitude, lng: userLocation.coordinate.longitude)
                    self.mainView.updateButtonTitle(title: Strings.Common.currentLocation)
                }
            }
        }
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func regionChangeObserver(notification: NSNotification) {
        if let region = notification.userInfo?["region"] as? String {
            
            if mainView.selectRegionButton.titleLabel?.text == region {
                print("기존꺼 그대로 선택")
                return
            }
            
            let selectedRegionType = RegionType.allCases.first { $0.name == region }
            if let selectedRegionType {
                print("업데이트 데이터")
//                mainView.mapView.showsUserLocation = false
                mainView.mapView.removeAnnotations(mainView.mapView.annotations)
                mainView.updateButtonTitle(title: region)
                viewModel?.fetchStoryByLocation(lat: selectedRegionType.latitude, lng: selectedRegionType.longitude)
            }
        }
    }
    
    private func addMarker(story: StoryItem) {
        let lat = Double(story.mapY)
        let lng = Double(story.mapX)
        guard let lat, let lng else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
        mainView.mapView.setRegion(region, animated: true)
        // 지도에 어노테이션 추가
        let annotation = MKPointAnnotation()
        annotation.title = story.audioTitle
        annotation.coordinate = center
        mainView.mapView.addAnnotation(annotation)
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

extension DetailRegionMapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        switch annotation {
        case is MKClusterAnnotation:
            let clusterAnotaionView = mapView.dequeueReusableAnnotationView(
                withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation) as? ClusterAnnotationView
            return clusterAnotaionView
        case is MKPointAnnotation:
            self.mainView.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation)
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier) as? CustomAnnotationView
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier).setup { view in
                    view.canShowCallout = false
                }
            } else {
                annotationView!.annotation = annotation
            }
            
            let customAnnotaionImageUrl = stories.first { $0.audioTitle == annotation.title }?.imageURL ?? ""
            annotationView?.addImage(imagePath: customAnnotaionImageUrl)
            return annotationView
            
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // TODO: 어노테이션은 클릭시 그냥 하단 컬렉션뷰에 리스트아이템 1개 추가해서 보여주기
        // TODO: 클러스터링은 클릭시 색깔 변화시킨 후 하단 컬렉션뷰에 리스트 띄우기
      
        switch view {
        case is ClusterAnnotationView:
            let selectedClusterView = view as? ClusterAnnotationView
            if let cluster = view.annotation as? MKClusterAnnotation {
                let memberAnnotations = cluster.memberAnnotations
                selectedClusterView?.selectedDrawRatio(to: memberAnnotations.count, wholeColor: .selectedBackgroundButton)
//                memberAnnotations.forEach { annotation in
//                    print("cluster = ", annotation.title)
//                }
            }
            
        case is CustomAnnotationView:
            let selectedAnnotationView = view as? CustomAnnotationView
            guard let selectedAnnotationView else { return }
            print(#function, view.annotation?.title, " clicked")
        default: Void()
        }
    }
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        return MKClusterAnnotation(memberAnnotations: memberAnnotations)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        switch view {
        case is ClusterAnnotationView:
            let deSelectedClusterView = view as? ClusterAnnotationView
            if let cluster = view.annotation as? MKClusterAnnotation {
                let memberAnnotations = cluster.memberAnnotations
                deSelectedClusterView?.defaultDrawRatio(to: memberAnnotations.count, wholeColor: .backgroundButton)
//                memberAnnotations.forEach { annotation in
//                    print("cluster = ", annotation.title)
//                }
            }
//        case is CustomAnnotationView:
//            let selectedAnnotationView = view as? CustomAnnotationView
//            guard let selectedAnnotationView else { return }
//            print(#function, view.annotation?.title, "클릭 해제")
//            selectedAnnotationView.resetAnnotationView()
        default: Void()
        }
    }
}

extension DetailRegionMapVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DetailRegionMapVC: CLLocationManagerDelegate {
    
    // TODO: 실행 테스트 필요
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(#function ,locations)
//        if let coordinate = locations.last?.coordinate {
//            print("coordinate = \(coordinate)")
//            viewModel?.fetchStoryByLocation(lat: coordinate.latitude, lng: coordinate.longitude)
////            LocationManager.shared.stopUpdating()
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error.localizedDescription)
        showToast(msg: Strings.ErrorMsg.errorLocation)
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
