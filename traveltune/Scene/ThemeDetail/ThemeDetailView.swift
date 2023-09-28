//
//  ThemeDetailView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit
import Hero
import SnapKit

final class ThemeDetailView: BaseView {
    
    let backgroundImageView = UIImageView().setup { view in
        view.hero.id = Constant.HeroID.themeThumnail
        view.contentMode = .scaleAspectFill
    }
    
    override func configureHierarchy() {
        addSubview(backgroundImageView)
    }
    
    override func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
