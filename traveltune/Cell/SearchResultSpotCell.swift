//
//  SearchResultSpotCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/05.
//

import UIKit
import SnapKit

final class SearchResultSpotCell: BaseCollectionViewCell<TravelSpotItem> {
    
    private let containerView = UIView()
    
    private let thumbImageView = ThumbnailImageView(frame: .zero)
    
    private let textContainerView = UIView()
    
    private let titleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 14, weight: .bold)
        view.textColor = .txtPrimary
    }
    
    private let addrLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 11, weight: .light)
        view.textColor = .txtSecondary
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = .defaultImg
    }
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(thumbImageView)
        containerView.addSubview(textContainerView)
        textContainerView.addSubview(titleLabel)
        textContainerView.addSubview(addrLabel)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(4)
            make.height.equalTo(self.snp.width).multipliedBy(0.7)
        }
        
        textContainerView.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview()
        }
        
        addrLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configCell(row: TravelSpotItem) {
        thumbImageView.addImage(url: row.imageURL)
        titleLabel.text = row.title
        addrLabel.text = row.fullAddr
    }
    
}
