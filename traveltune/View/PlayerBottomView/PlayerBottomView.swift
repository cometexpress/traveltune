//
//  PlayerBottomView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/01.
//

import UIKit
import SnapKit
import Kingfisher

final class PlayerBottomView: UIView {
    
    weak var playerBottomProtocol: PlayerBottomProtocol?
    
    let audioSlider = AudioUISlider(frame: .zero).setup { view in
//        view.addTarget(self, action: #selector(didChangedProgressBar(_:)), for: .valueChanged)
    }
    
    private let playContainerView = UIView()
    
    private lazy var previousImageView = AudioImageView(frame: .zero).setup { view in
        view.addImage(image: .skipPrevious)
        let tap = UITapGestureRecognizer(target: self, action: #selector(previousStoryClicked))
        view.addGestureRecognizer(tap)
    }
    
    private lazy var playAndPauseImageView = AudioImageView(frame: .zero).setup { view in
        view.addConfigImage(image: .playFill, configuration: .init(pointSize: 50, weight: .black))
        let tap = UITapGestureRecognizer(target: self, action: #selector(playAndPauseStoryClicked))
        view.addGestureRecognizer(tap)
    }
    
    private lazy var nextImageView = AudioImageView(frame: .zero).setup { view in
        view.addImage(image: .skipNext)
        let tap = UITapGestureRecognizer(target: self, action: #selector(nextStoryClicked))
        view.addGestureRecognizer(tap)
    }
    
    lazy var thumbImageView = ThumbnailImageView(frame: .zero).setup { view in
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(thumbImageViewClicked))
        view.addGestureRecognizer(tap)
    }
    
    let titleLabel = UILabel().setup { view in
        view.text = Strings.Common.selectPlayStory
        view.textColor = .txtThemeStory
        view.textAlignment = .center
        view.font = .monospacedSystemFont(ofSize: 14, weight: .semibold)
    }
    
    @objc private func previousStoryClicked() {
        playerBottomProtocol?.previousClicked()
    }
    
    @objc private func nextStoryClicked() {
        playerBottomProtocol?.nextClicked()
    }
    
    @objc private func playAndPauseStoryClicked() {
        playerBottomProtocol?.playAndPauseClicked()
    }
    
    @objc func thumbImageViewClicked() {
        playerBottomProtocol?.thumbImageClicked()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(title: String, thumbnail: String) {
        titleLabel.text = title
        if thumbnail.isEmpty {
            thumbImageView.image = .defaultImg
        } else {
            thumbImageView.addImage(url: thumbnail)
        }
        addPlayAndPauseImage(isPlaying: false)
    }
    
    func resetData() {
        titleLabel.text = Strings.Common.selectPlayStory
        addPlayAndPauseImage(isPlaying: true)
        thumbImageView.image = nil
        audioSlider.value = 0
    }
    
    func addPlayAndPauseImage(isPlaying: Bool) {
        let image: UIImage = isPlaying ? .playFill : .pauseFill
        playAndPauseImageView.addConfigImage(image: image, configuration: .init(pointSize: 50, weight: .black))
    }
    
    private func configureHierarchy() {
        addSubview(titleLabel)
        addSubview(audioSlider)
        addSubview(playContainerView)
        playContainerView.addSubview(previousImageView)
        playContainerView.addSubview(playAndPauseImageView)
        playContainerView.addSubview(nextImageView)
        playContainerView.addSubview(thumbImageView)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        audioSlider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
        }
        
        playContainerView.snp.makeConstraints { make in
            make.top.equalTo(audioSlider.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        playAndPauseImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        previousImageView.snp.makeConstraints { make in
            make.trailing.equalTo(playAndPauseImageView.snp.leading).offset(-24)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        nextImageView.snp.makeConstraints { make in
            make.leading.equalTo(playAndPauseImageView.snp.trailing).offset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }
    }
}
