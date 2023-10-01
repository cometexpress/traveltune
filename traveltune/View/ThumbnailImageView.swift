//
//  ThumbnailImageView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/01.
//

import UIKit
import Kingfisher

final class ThumbnailImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    func addImage(url: String) {
        if let url = URL(string: url) {
            kf.setImage(
                with: url,
                placeholder: UIImage(named: "default_img"),
                options: [
                    .transition(.fade(0.5)),
                    .processor(DownsamplingImageProcessor(size: CGSize(width: 120, height: 120))),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ]
            )
        }
    }
}