//
//  StoryScriptView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit
import SnapKit

final class StoryScriptView: BaseView {
    
    override var viewBg: UIColor { .black.withAlphaComponent(0.8) }
    
    private lazy var closeButton = UIButton().setup { view in
        var config = UIButton.Configuration.plain()
        config.image = .chevronDown
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .clear
        view.configuration = config
        view.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
    }
    
    private let containerView = UIView()
    
    let audioTitleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 16, weight: .semibold)
        view.textColor = .white
        view.numberOfLines = 0
        view.textAlignment = .center
    }
    
    let scriptTextView = UITextView().setup { view in
        view.isEditable = false
        view.isSelectable = false
    }
    
    var closeClicked: (() -> Void)?
    
    @objc private func closeButtonClicked() {
        closeClicked?()
    }
    
    func updateData(title: String, script: String) {
        scriptTextView.text = nil
        audioTitleLabel.text = title
        scriptTextView.text = script.replacingOccurrences(of: "  ", with: "\n\n")
        
        // 데이터가 들어간 이후 세팅해줘야 적용되고 있음
        scriptTextView.setLineSpacing(spacing: 8)
        scriptTextView.textColor = .white
        scriptTextView.textContainer.lineBreakMode = .byCharWrapping
        scriptTextView.font = .monospacedSystemFont(ofSize: 14, weight: .semibold)
        
        // 스크립트데이터 변경 후 Top 으로 스크롤 이동
        self.scriptTextView.setContentOffset(.zero, animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func configureHierarchy() {
        clipsToBounds = true
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.cornerRadius = 20
        isHidden = true
        
        addSubview(closeButton)
        addSubview(containerView)
        containerView.addSubview(audioTitleLabel)
        containerView.addSubview(scriptTextView)
    }
    
    override func configureLayout() {
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.size.equalTo(44)
            make.centerX.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.top.equalTo(closeButton.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(20)
        }
        
        audioTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        scriptTextView.snp.makeConstraints { make in
            make.top.equalTo(audioTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
