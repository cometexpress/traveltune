//
//  CircleView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/29.
//

import UIKit

final class CircleImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    private func configureView() {
        clipsToBounds = true
    }
}
