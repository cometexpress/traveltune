//
//  SplashView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit
import SnapKit

final class SplashView: BaseView {
    
    private let logoImageView = UIImageView()
    
    override func configureHierarchy() {
        addSubview(logoImageView)
    }
    
    override func configureLayout() {
        logoImageView.backgroundColor = .link
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
    }
}
