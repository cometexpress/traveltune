//
//  StoryCell.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/29.
//

import UIKit
import SnapKit

final class StoryCell: BaseCollectionViewCell<StoryItem> {
    
    private let leftView = UIView()
    
    private lazy var textStackView = UIStackView().setup { view in
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .equalSpacing
        view.spacing = 8
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelContentClicked))
        view.addGestureRecognizer(tap)
    }
    
    private let buttonStackView = UIStackView().setup { view in
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.spacing = 4
    }
    
    private let titleLabel = UILabel().setup { view in
        view.textColor = .whiteOpacity50
        view.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
    }
    
    private let playTimeLabel = UILabel().setup { view in
        view.textColor = .whiteOpacity50
        view.font = .monospacedSystemFont(ofSize: 11, weight: .light)
    }
    
    private let thumbImageView = UIImageView().setup { view in
        view.contentMode = .scaleAspectFill
        view.image = .defaultImg
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
    }
    
    private lazy var playImageView = AudioImageView(frame: .zero).setup { view in
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        view.addImage(image: .playFill.withConfiguration(configuration))
        let tap = UITapGestureRecognizer(target: self, action: #selector(playClicked))
        view.addGestureRecognizer(tap)
    }
    
    private lazy var heartImageView = AudioImageView(frame: .zero).setup { view in
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        view.addImage(image: .heart.withConfiguration(configuration))
        let tap = UITapGestureRecognizer(target: self, action: #selector(heartClicked))
        view.addGestureRecognizer(tap)
    }
    
    var playButtonClicked: (() -> Void)?
    var heartButtonClicked: (() -> Void)?
    var contentClicked: (() -> Void)?
    
    @objc private func playClicked() {
        playButtonClicked?()
    }
   
    @objc private func heartClicked() {
        heartButtonClicked?()
    }
    
    @objc private func labelContentClicked() {
        contentClicked?()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(leftView)
        contentView.addSubview(buttonStackView)
        leftView.addSubview(thumbImageView)
        leftView.addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(playTimeLabel)
        buttonStackView.addArrangedSubview(playImageView)
        buttonStackView.addArrangedSubview(heartImageView)
    }
    
    override func configureLayout() {
        leftView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        leftView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.74)
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
        
        buttonStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(leftView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        playImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        heartImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
    }
    
    override func configCell(row: StoryItem) {
        titleLabel.text = row.audioTitle.isEmpty ? row.title : row.audioTitle
        playTimeLabel.text = row.convertTime
        if let url = URL(string: row.imageURL) {
            thumbImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "default_img"),
                options: [.transition(.fade(1)), .forceTransition]
            )
        }
    }
    
    func changePlayItemColor() {
        titleLabel.textColor = .subGreen
        playTimeLabel.textColor = .subGreen
    }
    
}
