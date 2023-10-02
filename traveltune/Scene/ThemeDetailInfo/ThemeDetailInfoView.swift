//
//  ThemeDetailInfoView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit
import SnapKit

final class ThemeDetailInfoView: BaseView {
    
    override var viewBg: UIColor { .clear }
    
    private let containerView = UIView().setup { view in
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .bottomSheetBackground
    }
    
    private lazy var closeButton = UIButton().setup { view in
        var config = UIButton.Configuration.plain()
        config.image = .xmark
        config.baseForegroundColor = .txtPrimary
        config.baseBackgroundColor = .clear
        view.configuration = config
        view.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
    }
    
    let mainThumbImageView = UIImageView().setup { view in
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
    }
    
    let titleLabel = UILabel().setup { view in
        view.font = .monospacedDigitSystemFont(ofSize: 16, weight: .semibold)
        view.textColor = .txtPrimary
        view.textAlignment = .center
    }
    
    let contentLabel = UILabel().setup { view in
        view.font = .monospacedDigitSystemFont(ofSize: 14, weight: .light)
        view.textColor = .txtPrimary
        view.numberOfLines = 0
    }
    
    var closeClicked: (() -> Void)?
    
    @objc private func closeButtonClicked() {
        closeClicked?()
    }
    
    override func configureHierarchy() {
        addSubview(containerView)
        containerView.addSubview(closeButton)
        containerView.addSubview(mainThumbImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            make.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.horizontalEdges.equalToSuperview().inset(60)
        }
        
        mainThumbImageView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(self.snp.height).multipliedBy(0.4)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(mainThumbImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(mainThumbImageView).inset(4)
            make.bottom.equalToSuperview().inset(22)
        }
    }
}
