//
//  SearchTagCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/03.
//

import UIKit
import SnapKit

final class SearchTagCell: BaseCollectionViewCell<String> {
    
    private let containerView = UIView().setup { view in
        view.isUserInteractionEnabled = false
    }
    
    lazy var wordButton = UIButton().setup { view in
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 0.7
        view.layer.borderColor = UIColor.txtSecondary.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordButton.setTitle(nil, for: .normal)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(wordButton)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        wordButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configCell(row: String) {
        var attString = AttributedString(row)
        attString.font = .monospacedSystemFont(ofSize: 13, weight: .light)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.baseBackgroundColor = .background
        config.baseForegroundColor = .txtPrimary
        wordButton.configuration = config
    }
    
}

