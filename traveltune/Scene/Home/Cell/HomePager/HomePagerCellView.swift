//
//  HomePagerCellView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import UIKit
import SnapKit

final class HomePagerCellView: BaseView {
    
    let guideLabel = UILabel().setup { view in
        view.textColor = .txtPrimary
        view.textAlignment = .center
        view.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
    }
    
    let thumbImageView = UIImageView(frame: .zero).setup { view in
        view.contentMode = .scaleAspectFit
    }
    
    let bottomContainerView = UIView(frame: .zero).setup { view in
        view.backgroundColor = .koreaMapTint
        view.isUserInteractionEnabled = true
    }
    
    override func configureHierarchy() {
        backgroundColor = .systemYellow
        addSubview(thumbImageView)
        addSubview(bottomContainerView)
        bottomContainerView.addSubview(guideLabel)
    }
    
    override func configureLayout() {
        bottomContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(bottomContainerView.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(12)
        }
    }
}
