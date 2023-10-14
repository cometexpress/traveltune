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
    
    private let defaultSize = 36
    private let selectedSize = 100
    
    private var imageURL: String?
    
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
        setUI()
    }
    
    convenience init(imageURL: String) {
        self.init()
        self.imageURL = imageURL
        clusteringIdentifier = CustomAnnotationView.identifier
        addImage(imagePath: imageURL)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        print(#function, " = \(imageURL)")
        addImage(imagePath: imageURL ?? "")
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
        self.imageURL = imagePath
        if !imagePath.isEmpty {
            print("이미지 주소 - ", imagePath)
            thumbImageView.addImage(url: imagePath)
        } else {
            thumbImageView.image = .defaultImg
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

