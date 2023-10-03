//
//  TitleSupplementaryView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/03.
//

import UIKit
import SnapKit

class TitleSupplementaryView: UICollectionReusableView {
    
    let titleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 16, weight: .semibold)
        view.textColor = .txtPrimary
    }
    static let reuseIdentifier = "title-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}

