//
//  HomePagerCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import UIKit
import SnapKit
import FSPagerView

final class HomePagerCollectionViewCell: FSPagerViewCell, BaseCellProtocol {
    
    typealias Model = ThemeStory
    
    private let containerView = HomePagerCellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(row: ThemeStory) {
        containerView.thumbImageView.image = row.thumbnail
        containerView.themeLabel.text = row.title
        containerView.themeImageView.image = row.miniThumbnail
        containerView.contentLabel.text = row.content
    }
}
