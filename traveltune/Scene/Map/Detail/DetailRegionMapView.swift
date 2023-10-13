//
//  DetailRegionMapView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import UIKit
import MapKit
import SnapKit

final class DetailRegionMapView: BaseView {
    
    weak var detailRegionMapViewProtocol: DetailRegionMapVCProtocol?
    
    let mapView = ExcludeMapView().setup { view in
        view.showsUserLocation = true       // 유저 위치
        view.setCameraZoomRange(.init(maxCenterCoordinateDistance: 1000000), animated: true)
        view.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        view.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    private lazy var currentMyLocationView = CircleImageButtonView().setup { view in
        view.setView(backgroundColor: .primary, image: .scope)
        let tap = UITapGestureRecognizer(target: self, action: #selector(currentMyLocationClicked))
        view.addGestureRecognizer(tap)
    }
    
    lazy var selectRegionButton = UIButton().setup { view in
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(selectRegionButtonClicked(_ :)), for: .touchUpInside)
    }
    
    @objc private func currentMyLocationClicked() {
        detailRegionMapViewProtocol?.currentLocationClicked()
    }
    
    @objc private func selectRegionButtonClicked(_ sender: UIButton) {
        detailRegionMapViewProtocol?.selectRegionButtonClicked(item: (sender.titleLabel?.text)!)
    }
    
    func updateButtonTitle(title: String) {
        var attString = AttributedString(title)
        attString.font = .systemFont(ofSize: 16, weight: .semibold)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 6, leading: 12, bottom: 6, trailing: 12)
        config.image = .chevronDown.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12, weight: .light)).withTintColor(.white, renderingMode: .alwaysTemplate)
        config.imagePadding = 4
        config.imagePlacement = .trailing
        config.baseBackgroundColor = .primary
        config.baseForegroundColor = .white
        selectRegionButton.configuration = config
    }
    
    override func configureHierarchy() {
        addSubview(mapView)
        addSubview(currentMyLocationView)
        addSubview(selectRegionButton)
    }
    
    override func configureLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        currentMyLocationView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(44)
        }
        
        selectRegionButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentMyLocationView)
            make.leading.equalToSuperview().inset(20)
        }
    }
}
