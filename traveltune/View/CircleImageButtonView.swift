//
//  CircleImageButtonView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/09.
//

import UIKit
import SnapKit

final class CircleImageButtonView: UIView {
    
    private let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 24, height: 24)).setup { view in
        view.tintColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func config() {
        isUserInteractionEnabled = true
        clipsToBounds = true
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    func setView(backgroundColor: UIColor, image: UIImage) {
        self.backgroundColor = backgroundColor
        imageView.image = image.withTintColor(.white, renderingMode: .alwaysTemplate)
    }
    
}
