//
//  SearchResultStoryCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/06.
//

import UIKit
import SnapKit

final class SearchResultStoryCell: BaseCollectionViewCell<Int> {
    
    private let containerView = UIView()
    
    private let thumbImageView = ThumbnailImageView(frame: .zero)
    
    private let textContainerView = UIView()
    
    private let titleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        view.textColor = .txtPrimary
    }
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(thumbImageView)
        containerView.addSubview(textContainerView)
        textContainerView.addSubview(titleLabel)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configCell(row: Int) {
//        thumbImageView.addImage(url: row.imageURL)
//        titleLabel.text = row.title
    }
    
}
