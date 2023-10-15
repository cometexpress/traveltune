//
//  SettingCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/15.
//

import UIKit
import SnapKit

final class SettingCell: BaseCollectionViewCell<SettingItem> {
    
    private let titleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 14, weight: .light)
        view.textColor = .txtPrimary
    }
    
    private let rightLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 14, weight: .semibold)
        view.textColor = .txtDisabled
    }
    
    private let arrowImageView = UIImageView().setup { view in
        view.image = .chevronForward.withRenderingMode(.alwaysTemplate)
        view.tintColor = .txtDisabled
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(arrowImageView)
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configCell(row: SettingItem) {
        titleLabel.text = row.title
        rightLabel.text = row.rightTitle
    }
}
