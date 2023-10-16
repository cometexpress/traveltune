//
//  AudioImageView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/29.
//

import UIKit

final class AudioImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImage(image: UIImage) {
        self.image = image.withTintColor(.backgroundAuidioImg, renderingMode: .alwaysOriginal)
    }
    
    func addConfigImage(image: UIImage, configuration: UIImage.SymbolConfiguration) {
        addImage(image: image.withConfiguration(configuration))
    }
    
}
