//
//  ClusterAnnotationView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/13.
//

import MapKit

final class ClusterAnnotationView: MKAnnotationView {
    
    private let clusterSize: CGFloat = 42.0
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
        isExclusiveTouch = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            let memberAnnotations = cluster.memberAnnotations.count
            if memberAnnotations > 1 {
                defaultDrawRatio(to: memberAnnotations, wholeColor: .backgroundButton)
                displayPriority = .defaultHigh
            }
        }
    }
    
    func defaultDrawRatio(to whole: Int, wholeColor: UIColor?) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: clusterSize, height: clusterSize))
        let defaultImage = renderer.image { _ in
            wholeColor?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: clusterSize, height: clusterSize)).fill()
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                               NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 18, weight: .regular)]
            let text = "\(whole)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(
                x: (clusterSize / 2) - size.width / 2,
                y: (clusterSize / 2) - size.height / 2,
                width: size.width,
                height: size.height
            )
            text.draw(in: rect, withAttributes: attributes)
        }
        image = defaultImage
        setNeedsLayout()
    }
    
    func selectedDrawRatio(to whole: Int, wholeColor: UIColor?) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: clusterSize, height: clusterSize))
        let selectedImage = renderer.image { _ in
            wholeColor?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: clusterSize, height: clusterSize)).fill()
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                               NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 18, weight: .regular)]
            let text = "\(whole)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(
                x: (clusterSize / 2) - (size.width / 2),
                y: (clusterSize / 2) - size.height / 2,
                width: size.width,
                height: size.height
            )
            text.draw(in: rect, withAttributes: attributes)
        }
        image = selectedImage
        setNeedsLayout()
    }
}
