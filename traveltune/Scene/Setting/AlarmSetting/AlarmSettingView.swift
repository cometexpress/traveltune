//
//  AlarmSettingView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/20.
//

import UIKit
import SnapKit

final class AlarmSettingView: BaseView {
    
    let baseNotiContainerView = UIView()
    
    private let baseNotiLabel = UILabel().setup { view in
        view.text = Strings.Setting.settingNotificationServiceTitle
        view.textColor = .txtPrimary
        view.font = .monospacedSystemFont(ofSize: 16, weight: .regular)
    }
    
    let baseNotiSwicth = UISwitch().setup { view in
        view.setOn(false, animated: true)
        view.onTintColor = .primary
        view.thumbTintColor = .txtPrimary
    }

    let requsetNotiPermissionButton = UIButton().setup { view in
        view.isHidden = true
        var attString = AttributedString(Strings.Setting.settingNotificationSettingButton)
        attString.font = .systemFont(ofSize: 16, weight: .medium)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        config.baseBackgroundColor = .primary
        config.baseForegroundColor = .white
        view.configuration = config
    }
    
    let notificationGuideLabel = UILabel().setup { view in
        view.isHidden = true
        view.text = Constant.productName + Strings.Setting.settingNotificationGuideContent
        view.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        view.textColor = .txtPrimary
        view.textAlignment = .center
        view.numberOfLines = 0
    }
    
    override func configureHierarchy() {
        addSubview(baseNotiContainerView)
        baseNotiContainerView.addSubview(baseNotiLabel)
        baseNotiContainerView.addSubview(baseNotiSwicth)
        addSubview(requsetNotiPermissionButton)
        addSubview(notificationGuideLabel)
    }
    
    override func configureLayout() {
        baseNotiContainerView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        baseNotiLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        baseNotiSwicth.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        requsetNotiPermissionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(baseNotiContainerView.snp.bottom).offset(20)
        }
        
        notificationGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(requsetNotiPermissionButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
