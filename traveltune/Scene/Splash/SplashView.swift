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
    
    override var viewBg: UIColor { .primary }
    
    let indicatorView = UIActivityIndicatorView().setup { view in
        view.hidesWhenStopped = true
        view.isHidden = false
        view.startAnimating()
        view.color = .white
    }
    
    override func configureHierarchy() {
        addSubview(logoImageView)
        addSubview(indicatorView)
    }
    
    override func configureLayout() {
        logoImageView.backgroundColor = .link
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(50)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
    }
}
