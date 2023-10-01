//
//  StoryCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/29.
//

import UIKit
import SnapKit
import Kingfisher

final class StoryCell: BaseCollectionViewCell<StoryItem> {
    
    private let leftView = UIView()
    
    private lazy var textStackView = UIStackView().setup { view in
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.spacing = 4
    }
    
    private let titleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
    }
    
    private let playTimeLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 11, weight: .light)
    }
    
    private let thumbImageView = ThumbnailImageView(frame: .zero).setup { view in
        view.image = .defaultImg
    }
    
    private lazy var heartImageView = AudioImageView(frame: .zero).setup { view in
        let tap = UITapGestureRecognizer(target: self, action: #selector(heartClicked))
        view.addGestureRecognizer(tap)
    }
    
    var heartButtonClicked: (() -> Void)?
   
    @objc private func heartClicked() {
        heartButtonClicked?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = .defaultImg
    }
    
    override func configureHierarchy() {
        contentView.addSubview(leftView)
        leftView.addSubview(thumbImageView)
        leftView.addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(playTimeLabel)
        contentView.addSubview(heartImageView)
    }
    
    override func configureLayout() {
        leftView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        heartImageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        leftView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.83)
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.size.equalTo(leftView.snp.height)
            make.leading.equalToSuperview().offset(16)
        }
        
        textStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(thumbImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        playTimeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        heartImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        heartImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    override func configCell(row: StoryItem) {
        titleLabel.text = row.audioTitle.isEmpty ? row.title : row.audioTitle
        playTimeLabel.text = row.convertTime
        thumbImageView.addImage(url: row.imageURL)
        heartImageView.addConfigImage(image: row.isFavorite ? .heartFill : .heart, configuration: .init(pointSize: 24, weight: .medium))
        
        titleLabel.textColor = row.isPlaying ? .subGreen : .txtThemeStory
        playTimeLabel.textColor = row.isPlaying ? .subGreen : .txtThemeStory
    }
    
}
