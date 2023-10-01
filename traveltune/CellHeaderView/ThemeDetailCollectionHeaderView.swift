//
//  ThemeDetailCollectionHeaderView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/29.
//

import UIKit
import SnapKit
import Kingfisher

final class ThemeDetailCollectionHeaderView: UICollectionReusableView {
    
    let thumbImageView = CircleImageView(frame: .zero).setup { view in
        view.contentMode = .scaleAspectFill
        view.image = .defaultImg
    }
    
    lazy var slider = AudioUISlider(frame: .zero).setup { view in
        view.addTarget(self, action: #selector(didChangedProgressBar(_:)), for: .valueChanged)
    }
    
    private let playerView = UIView()
    
    private lazy var previousImageView = AudioImageView(frame: .zero).setup { view in
        view.addImage(image: .skipPrevious)
        let tap = UITapGestureRecognizer(target: self, action: #selector(previousStoryClicked))
        view.addGestureRecognizer(tap)
    }
    
    private lazy var playAndPauseImageView = AudioImageView(frame: .zero).setup { view in
        view.addImage(image: .playCircle)
        let tap = UITapGestureRecognizer(target: self, action: #selector(playAndPauseStoryClicked))
        view.addGestureRecognizer(tap)
    }
    
    private lazy var nextImageView = AudioImageView(frame: .zero).setup { view in
        view.addImage(image: .skipNext)
        let tap = UITapGestureRecognizer(target: self, action: #selector(nextStoryClicked))
        view.addGestureRecognizer(tap)
    }
    
    var previousClicked: (() -> Void)?
    var nextClicked: (() -> Void)?
    var playAndPauseClicked: (() -> Void)?
    
    var sliderValueChanged: ((Float)-> Void)?
    
    @objc func previousStoryClicked() {
        previousClicked?()
    }
    
    @objc func nextStoryClicked() {
        nextClicked?()
    }
    
    @objc func playAndPauseStoryClicked() {
        playAndPauseClicked?()
    }
    
    @objc func didChangedProgressBar(_ sender: UISlider) {
        // 유저가 직접 손으로 변경했을 때 오디오 위치 조정 필요
        sliderValueChanged?(sender.value)
        print("슬라이더 = ",sender.value)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(thumbImageView)
        addSubview(slider)
        addSubview(playerView)
        playerView.addSubview(previousImageView)
        playerView.addSubview(playAndPauseImageView)
        playerView.addSubview(nextImageView)
    }
    
    private func configureLayout() {
        thumbImageView.snp.makeConstraints { make in
            make.size.equalTo(self.snp.height).multipliedBy(0.5)
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        slider.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
            make.centerX.equalToSuperview()
            make.top.equalTo(thumbImageView.snp.bottom).offset(16)
        }
        
        playerView.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.top.equalTo(slider.snp.bottom)
            make.bottom.equalToSuperview().inset(16)
        }
        
        playAndPauseImageView.snp.makeConstraints { make in
            make.size.equalTo(playerView.snp.height).multipliedBy(0.9)
            make.center.equalToSuperview()
        }
        
        previousImageView.snp.makeConstraints { make in
            make.size.equalTo(playerView.snp.height).multipliedBy(0.6)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        nextImageView.snp.makeConstraints { make in
            make.size.equalTo(playerView.snp.height).multipliedBy(0.6)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configView(item: StoryItem) {
        let url = URL(string: item.imageURL)
        thumbImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "default_img"),
            options: [.transition(.fade(1)), .forceTransition]
        )
        
        let playTime = Float(Int(item.playTime) ?? 0)
        slider.maximumValue = playTime
    }
}
