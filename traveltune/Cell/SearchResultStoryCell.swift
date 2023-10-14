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
    
    private let textStackView = UIStackView().setup { view in
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.axis = .vertical
        view.spacing = 4
    }
    
    private let titleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 14, weight: .bold)
        view.textColor = .txtPrimary
    }
    
    private let scriptLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 11, weight: .light)
        view.numberOfLines = 2
        view.textColor = .txtSecondary
    }
    
    private let playTimeLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 11, weight: .light)
        view.textColor = .txtSecondary
        view.textAlignment = .right
    }
    
    private let dividerLine = UIView().setup { view in
        view.backgroundColor = .divider
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = .defaultImg
    }
    
    override func configureHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(thumbImageView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(scriptLabel)
        containerView.addSubview(textStackView)
        containerView.addSubview(playTimeLabel)
        contentView.addSubview(dividerLine)
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(16)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.height)
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(6)
        }
        
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(thumbImageView.snp.trailing).offset(16)
            make.top.equalToSuperview().inset(8)
//            make.verticalEdges.equalTo(thumbImageView).inset(20)
            make.trailing.equalToSuperview().inset(6)
        }
        
        playTimeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(6)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configCell(row: StoryItem) {
        thumbImageView.addImage(url: row.imageURL)
        titleLabel.text = row.audioTitle
        
        if row.script.isEmpty {
            scriptLabel.text = Strings.Common.scriptInfoNoData
        } else {
            scriptLabel.text = item.script.replacingOccurrences(of: "  ", with: "\n\n").trimmingCharacters(in: .whitespacesAndNewlines)
        }
        playTimeLabel.text = "ᐅ " + row.convertTime
    }
    
}
