//
//  SearchResultStoryCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/06.
//

import UIKit
import SnapKit

final class SearchResultStoryCell: BaseCollectionViewCell<StoryItem> {
    
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
        
        thumbImageView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.height)
            make.verticalEdges.equalToSuperview().inset(6)
            make.leading.equalToSuperview().inset(6)
        }
        
        textContainerView.backgroundColor = .link
        textContainerView.snp.makeConstraints { make in
            make.leading.equalTo(thumbImageView.snp.trailing)
            make.verticalEdges.equalTo(thumbImageView)
            make.trailing.equalToSuperview().inset(6)
        }
    }
    
    override func configCell(row: StoryItem) {
        thumbImageView.addImage(url: row.imageURL)
        titleLabel.text = row.title
    }
    
}
