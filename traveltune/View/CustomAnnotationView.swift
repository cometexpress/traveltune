//
//  CustomAnnotaionView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/08.
//

import Foundation
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
//        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // MKAnnotationView 크기를 backgroundView 크기 만큼 정해줌.
        bounds.size = CGSize(width: 50, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    }

    private func setUI() {
        backgroundColor = .clear
        canShowCallout = true
        
        let accessoryView = UIButton(frame: CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: 20, height: 20))
        )
        accessoryView.setImage(.locationArrow, for: .normal)
        rightCalloutAccessoryView = accessoryView
        rightCalloutAccessoryView?.tintColor = .txtSecondary
    }
}

