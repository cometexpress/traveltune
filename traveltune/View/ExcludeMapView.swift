//
//  ExcludeMapView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/12.
//

import UIKit
import MapKit

final class ExcludeMapView: MKMapView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configStyle() {
        preferredConfiguration = MKStandardMapConfiguration()
        isPitchEnabled = false         // 각도 조절
        isRotateEnabled = false        // 회전
        showsCompass = false           // 나침반
//        view.showsUserLocation = true       // 유저 위치
        pointOfInterestFilter = .excludingAll
    }
}
