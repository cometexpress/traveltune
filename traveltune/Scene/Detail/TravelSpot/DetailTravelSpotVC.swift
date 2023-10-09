//
//  DetailTravelSpotVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/08.
//

import UIKit
import MapKit

final class DetailTravelSpotVC: BaseViewController<DetailTravelSpotView, DetailTravelSpotViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
        viewModel?.searchNearbySpots()
    }
    
    func bindViewModel() {
        viewModel?.detailTravelSpot.bind { [weak self] item in
            guard let item else { return }
            self?.mainView.fetchData(item: item)
        }
        
        viewModel?.state.bind { [weak self] state in
            switch state {
            case .initValue: Void()
            case .loading: 
                LoadingIndicator.show()
            case .success(let data):
                if data.isEmpty {
                    self?.mainView.hideNearbyCollectionView()
                } else {
                    self?.mainView.applySnapShot(items: data)
                }
                LoadingIndicator.hide()
            case .error(let msg):
                print(msg)
                LoadingIndicator.hide()
            }
        }
    }
    
    func configureVC() {
        mainView.mapView.delegate = self
        mainView.detailTravelSpotProtocol = self
        mainView.findDirectionButton.addTarget(self, action: #selector(findDerectionButtonClicked), for: .touchUpInside)
    }
    
    @objc private func findDerectionButtonClicked() {
        
        if let viewModel, let data = viewModel.detailTravelSpot.value {
            let lat = Double(data.mapY)
            let lng = Double(data.mapX)
            
            guard let lat, let lng else {
                showAlert(title: "", msg: Strings.Common.locationNoData, ok: Strings.Common.ok)
                return
            }

            showAlertModal(
                type: SchemeType.allCases,
                lat: lat,
                lng: lng,
                arrivalPoint: data.title
            )
        }
    }
    
    private func showAlertModal(
        type: [SchemeType],
        no: String? = Strings.Common.cancel,
        lat: Double,
        lng: Double,
        arrivalPoint: String,
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        type.forEach { type in
            let action = UIAlertAction(title: type.title, style: .default) { _ in
                switch type {
                case .kakao:
                    URLSchemeManager.shared.showURLScemeMap(type: .kakao(lat: lat, lng: lng))
                case .naver:
                    URLSchemeManager.shared.showURLScemeMap(type: .naver(lat: lat, lng: lng, dname: arrivalPoint))
                case .tmap:
                    URLSchemeManager.shared.showURLScemeMap(type: .naver(lat: lat, lng: lng, dname: arrivalPoint))
                case .apple:
                    URLSchemeManager.shared.convertCoordnatesToAddress(lat: lat, lng: lng) { address in
                        print(address)
                        let endPoint = address.isEmpty ? arrivalPoint : address
                        URLSchemeManager.shared.showURLScemeMap(type: .apple(arrivalPoint: endPoint))
                    }
                }
            }
            alert.addAction(action)
        }
        let noAction = UIAlertAction(title: no, style: .cancel)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
}

extension DetailTravelSpotVC: DetailTravelSpotProtocol {
    
    func backButtonClicked() {
        dismiss(animated: true)
    }
    
    func didSelectItemAt(item: TravelSpotItem) {
        let vc = DetailTravelSpotVC(viewModel: DetailTravelSpotViewModel(travelSportRepository: TravelSpotRepository()))
        vc.viewModel?.detailTravelSpot.value = item
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension DetailTravelSpotVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        let customAnnotaionImageUrl = viewModel?.detailTravelSpot.value?.imageURL ?? ""
        
        if customAnnotaionImageUrl.isEmpty {
            let thumbImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40)).setup { view in
                view.image = .defaultImg
                view.layer.cornerRadius = 8
                view.clipsToBounds = true
            }
            annotationView?.addSubview(thumbImageView)
            
        } else {
            let thumbImageView = ThumbnailImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40)).setup { view in
                view.contentMode = .scaleAspectFill
                view.layer.cornerRadius = 8
                view.clipsToBounds = true
            }
            thumbImageView.addImage(url: customAnnotaionImageUrl)
            annotationView?.addSubview(thumbImageView)
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //        print(view.annotation?.title, "clicked")
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let annotation = views.first(where: { $0.reuseIdentifier == CustomAnnotationView.identifier })?.annotation {
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        findDerectionButtonClicked()
    }
}
