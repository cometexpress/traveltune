//
//  HomePagerCellView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import UIKit
import SnapKit

final class HomePagerCellView: BaseView {
    
    private let titleView = UIView()
    
    let themeImageView = UIImageView(frame: .zero).setup { view in
        view.image = UIImage(systemName: "star.fill")
        view.tintColor = .txtSecondary
    }
    
    let themeLabel = UILabel().setup { view in
        view.textColor = .txtPrimary
        view.textAlignment = .center
        view.numberOfLines = 1
        view.font = .monospacedDigitSystemFont(ofSize: 18, weight: .semibold)
    }
    
    private let bottomContainerView = UIView()
    
    let thumbImageView = UIImageView(frame: .zero).setup { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFill
    }
    
    private let opacityView = UIView().setup { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor(.black).withAlphaComponent(0.4)
    }
    
    let contentLabel = UILabel().setup { view in
        view.textColor = .white
        view.numberOfLines = 2
        view.font = .monospacedSystemFont(ofSize: 15, weight: .medium)
    }
    
    let moveButton = UIButton().setup { view in
        var attString = AttributedString("PLAY")
        attString.font = .systemFont(ofSize: 16, weight: .medium)
        attString.foregroundColor = .txtPrimary
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.baseBackgroundColor = .grey500
        view.configuration = config
    }
    
    
    override func configureHierarchy() {
        backgroundColor = .clear
//        backgroundColor = .systemYellow
        addSubview(titleView)
        addSubview(bottomContainerView)
                
        titleView.addSubview(themeImageView)
        titleView.addSubview(themeLabel)
        
        bottomContainerView.addSubview(thumbImageView)
        bottomContainerView.addSubview(opacityView)
        bottomContainerView.addSubview(contentLabel)
        bottomContainerView.addSubview(moveButton)
    }
    
    override func configureLayout() {
//        titleView.backgroundColor = .cyan
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        themeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
        }
        
        themeLabel.snp.makeConstraints { make in
            make.top.equalTo(themeImageView.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        
//        bottomContainerView.backgroundColor = .primary
        bottomContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(8)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        //        thumbImageView.backgroundColor = .green
        thumbImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.88)
            make.horizontalEdges.equalToSuperview()
        }
        
        opacityView.snp.makeConstraints { make in
            make.edges.equalTo(thumbImageView)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.bottom.equalTo(moveButton.snp.top).offset(-12)
            make.horizontalEdges.equalToSuperview().inset(12)
        }

        //        moveButton.backgroundColor = .darkText
        moveButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(moveButton.snp.width).multipliedBy(0.3)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(thumbImageView.snp.bottom).offset(18)
        }
    }
}
