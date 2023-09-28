//
//  ThemePagerCollectionViewCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import UIKit
import FSPagerView
import Hero
import SnapKit


final class ThemePagerCollectionViewCell: FSPagerViewCell, BaseCellProtocol {
    
    typealias Model = ThemeStory
    
    private let containerView = ThemePagerCellView().setup { view in
        view.hero.id = Constant.HeroID.themeThumnail
    }
    
    var moveThemeDetailClicked: ((ThemeStory) -> Void)?
    
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
        containerView.themeImageView.image = row.miniThumbnail.withTintColor(.txtSecondary, renderingMode: .alwaysOriginal)
        containerView.contentLabel.text = row.content
        containerView.contentLabel.setLineSpacing(spacing: 8)
        containerView.contentLabel.lineBreakMode = .byTruncatingTail
        
        containerView.moveButton.addAction(.init(handler: { [weak self] _ in
            self?.moveThemeDetailClicked?(row)
        }), for: .touchUpInside)
    }
}
