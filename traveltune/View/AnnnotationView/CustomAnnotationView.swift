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
    
    private let defaultSize = 30
    private let selectedSize = 100
    
    private lazy var thumbImageView = ThumbnailImageView(frame: .init(x: 0, y: 0, width: defaultSize, height: defaultSize)).setup { view in
        view.image = .defaultImg
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
    }
    
    private let accessoryView = UIButton(frame: CGRect(
        origin: CGPoint.zero,
        size: CGSize(width: 20, height: 20))
    )
    
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = CustomAnnotationView.identifier
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultLow
        clusteringIdentifier = CustomAnnotationView.identifier
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // MKAnnotationView 크기를 backgroundView 크기 만큼 정해줌.
        //        bounds.size = CGSize(width: 50, height: 50)
        //        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        thumbImageView.image = nil
    }
    
    private func setUI() {
        frame = CGRect(x: 0, y: 0, width: defaultSize, height: defaultSize)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        addSubview(thumbImageView)
        backgroundColor = .clear
        //        canShowCallout = true
        accessoryView.setImage(.locationArrow, for: .normal)
        rightCalloutAccessoryView = accessoryView
        rightCalloutAccessoryView?.tintColor = .txtSecondary
    }
    
    func addImage(imagePath: String) {
        if !imagePath.isEmpty {
            thumbImageView.addImage(url: imagePath)
        }
    }
    
//    func selectedAnnotationView() {
//        thumbImageView.bounds = .init(x: 0, y: 0, width: selectedSize, height: selectedSize)
//        bounds.size = CGSize(width: selectedSize, height: selectedSize)
//        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
//        setNeedsLayout()
//    }
//    
//    func resetAnnotationView() {
//        thumbImageView.bounds = .init(x: 0, y: 0, width: defaultSize, height: defaultSize)
//        bounds.size = CGSize(width: 100, height: 100)
//        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
//        setNeedsLayout()
//    }
    
}

