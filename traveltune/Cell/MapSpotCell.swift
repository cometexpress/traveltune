//
//  MapSpotCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/10.
//

import UIKit
import SnapKit

final class MapSpotCell: BaseCollectionViewCell<String> {
    
    private let titleLabel = UILabel().setup { view in
        view.textColor = .txtPrimary
        view.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func configCell(row: String) {
        titleLabel.text = row
    }
}
