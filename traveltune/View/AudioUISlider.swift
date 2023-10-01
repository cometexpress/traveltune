//
//  AudioUISlider.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/29.
//

import UIKit

final class AudioUISlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: 3))
    }
    
    private func config() {
        minimumValue = 0
        minimumTrackTintColor = .primary
        maximumTrackTintColor = .translucent
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        setThumbImage(image, for: .normal)
        setThumbImage(image, for: .highlighted)
    }
}
