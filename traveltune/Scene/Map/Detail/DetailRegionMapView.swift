//
//  DetailRegionMapView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import UIKit
import CoreLocation
import MapKit
import SnapKit

final class DetailRegionMapView: BaseView {
    
    weak var detailRegionMapViewProtocol: DetailRegionMapVCProtocol?
    
    let mapView = ExcludeMapView().setup { view in
        view.showsUserLocation = true       // 유저 위치
    }
    
    private lazy var currentMyLocationView = CircleImageButtonView().setup { view in
        view.setView(backgroundColor: .primary, image: .scope)
        let tap = UITapGestureRecognizer(target: self, action: #selector(currentMyLocationClicked))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func currentMyLocationClicked() {
        detailRegionMapViewProtocol?.currentLocationClicked()
    }
    
    override func configureHierarchy() {
        addSubview(mapView)
        addSubview(currentMyLocationView)
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
    }
}
