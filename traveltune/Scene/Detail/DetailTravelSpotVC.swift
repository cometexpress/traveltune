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
    }
    
    func bindViewModel() {
        viewModel?.detailTravelSpot.bind { [weak self] item in
            guard let item else { return }
            self?.mainView.fetchData(item: item)
            print(item)
        }
    }
    
    func configureVC() {
        mainView.mapView.delegate = self
        mainView.detailTravelSpotProtocol = self
    }
        
}

extension DetailTravelSpotVC: DetailTravelSpotProtocol {
    
    func backButtonClicked() {
        dismiss(animated: true)
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
        //        print(mapView.annotations.first?.title)
        print(view.annotation?.title, "clicked")
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let annotation = views.first(where: { $0.reuseIdentifier == CustomAnnotationView.identifier })?.annotation {
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("123232")
    }
}
