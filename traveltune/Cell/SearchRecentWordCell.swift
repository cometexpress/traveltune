//
//  SearchRecentWordCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/03.
//

import UIKit
import SnapKit

final class SearchRecentWordCell: BaseCollectionViewCell<String> {
    
    private let containerView = UIView()
    
    private let wordLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        view.textColor = .txtPrimary
    }
    
    private lazy var deleteButton = UIButton().setup { view in
        var config = UIButton.Configuration.filled()
        config.image = .xmark
        config.baseBackgroundColor = .background
        config.baseForegroundColor = .txtDisabled
        view.configuration = config
        view.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
    }
    
    var deleteClicked: (() -> Void)?
    
    @objc private func deleteButtonClicked() {
        deleteClicked?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordLabel.text = nil
        deleteClicked = nil
    }
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(wordLabel)
        containerView.addSubview(deleteButton)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        wordLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(self.contentView.snp.width).multipliedBy(0.8)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    override func configCell(row: String) {
        wordLabel.text = row
    }
}
