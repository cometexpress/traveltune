//
//  DetailRegionMapVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import UIKit
import CoreLocation
import MapKit
import Kingfisher

final class DetailRegionMapVC: BaseViewController<DetailRegionMapView, DetailRegionMapViewModel> {
    
    deinit {
        LocationManager.shared.stopUpdating()
    }
    
    private var stories: [StoryItem] = []
    
    private var isTouchable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
        
        LocationManager.shared.startUpdating()
        LocationManager.shared.locationManager.delegate = self
        
        bindLocationAuthStatus()
        
        mainView.mapView.isMultipleTouchEnabled = false
    }
    
    @objc func touchAction (sender: UIPanGestureRecognizer) {
            
        print("터치터ㅣ터치")
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
                    self.mainView.mapView.setUserTrackingMode(.follow, animated: true)
                    
                    guard let userLocation = self.mainView.mapView.userLocation.location else {
                        print("유저 위치 없음")
                        self.showToast(msg: Strings.ErrorMsg.errorLocation)
                        return
                    }
                    
//                    mainView.updateUserLocation()
                    
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
        
        // 지도에 커스텀 어노테이션 추가
        let annotation = StoryAnnotation(item: story)
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
            no: Strings.Common.cancel
        ) { _ in
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
    
    func didSelectItemAt(item: StoryItem) {
        let vc = DetailStoryVC(
            viewModel: DetailStoryViewModel(
                storyRepository: StoryRepository(),
                localFavoriteStoryRepository: LocalFavoriteStoryRepository()
            )
        )
        vc.viewModel?.detailStory.value = item
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension DetailRegionMapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mainView.updateUserLocation()
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        // 이전에 권한 획득한 유저는 바로 유저 위치 저장하도록 viewDidLoad 에 추가
        mainView.updateUserLocation()
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        isTouchable = false
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        isTouchable = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        switch annotation {
        case is MKClusterAnnotation:
            let clusterAnotaionView = mapView.dequeueReusableAnnotationView(
                withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation) as? ClusterAnnotationView
            return clusterAnotaionView
            
        case is StoryAnnotation:
            let customAnnotation = annotation as? StoryAnnotation
            guard let customAnnotation else { return nil }
            let annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: CustomAnnotationView.identifier, for: customAnnotation) as? CustomAnnotationView
            
            guard let annotationView else { return nil }
            let customAnnotaionImageUrl = stories.first { $0.stid == customAnnotation.item.stid }?.imageURL ?? ""
            annotationView.addImage(imagePath: customAnnotaionImageUrl)
            return annotationView
            
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
            if !isTouchable {
                return
            }
            
            switch view {
            case is ClusterAnnotationView:
                let selectedClusterView = view as? ClusterAnnotationView
                if let cluster = view.annotation as? MKClusterAnnotation {
                    let memberAnnotations = cluster.memberAnnotations
                    selectedClusterView?.selectedDrawRatio(to: memberAnnotations.count, wholeColor: .selectedBackgroundButton)
                    self.mainView.selectedStoryItems = []
                    memberAnnotations.forEach { annotation in
                        if let storyAnnotation = annotation as? StoryAnnotation {
                            mainView.selectedStoryItems.append(storyAnnotation.item)
                        }
                    }
                    selectedClusterView?.setSelected(true, animated: false)
                    if !mainView.selectedStoryItems.isEmpty {
                        mainView.bottomCollectionView.scrollToItem(
                            at: IndexPath(item: 0, section: 0),
                            at: .left,
                            animated: false
                        )
                    }
                }
                
            case is CustomAnnotationView:
                let selectedAnnotationView = view as? CustomAnnotationView
                guard let selectedAnnotationView else { return }
                let storyAnnotation = selectedAnnotationView.annotation as? StoryAnnotation
                guard let storyAnnotation else { return }
                selectedAnnotationView.setSelected(true, animated: false)
                mainView.selectedStoryItems = []
                mainView.selectedStoryItems.append(storyAnnotation.item)
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
                mainView.selectedStoryItems.removeAll()
            }
            deSelectedClusterView?.setSelected(false, animated: false)
        case is CustomAnnotationView:
            let selectedAnnotationView = view as? CustomAnnotationView
            guard let selectedAnnotationView else { return }
            let storyAnnotation = selectedAnnotationView.annotation as? StoryAnnotation
            guard let storyAnnotation else { return }
            selectedAnnotationView.setSelected(false, animated: false)
            mainView.selectedStoryItems.removeAll()
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error.localizedDescription)
        showToast(msg: Strings.ErrorMsg.errorLocation)
    }
    
    // 거부했다가 설정에서 변경을 했거나 ,notDetermained 상태에서 허용을 했거나
    // 허용해서 위치를 가지고 오는 도중에 설정에서 거부를 하고 앱으로 다시 돌아올 때
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 어떤 권한인지는 모르고 권한이 바뀌는 것만 암,
        print(#function)
        checkAvailableCurrentLocation()
    }
}
