//
//  DetailStoryView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/09.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailStoryView: BaseView {
    
    weak var detailStoryProtocol: DetailStoryProtocol?
    
    private lazy var scrollView = UIScrollView().setup { view in
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
    }
    
    private let containerView = UIView().setup { view in
        view.backgroundColor = .background
    }
    
    private let imageContainerView = UIView()
    
    private let topView = UIView()
    
    private let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .regular)))
    
    private lazy var backButton = UIButton().setup { view in
        view.setImage(.backCircle.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        view.addTarget(self, action: #selector(backDetailStoryButtonClicked), for: .touchUpInside)
    }
    
    private let backBlurImageView = UIImageView().setup { view in
        view.contentMode = .scaleAspectFill
    }
    
    private let circleImageView = CircleImageView(frame: .zero).setup { view in
        view.contentMode = .scaleAspectFill
    }
    
    private let buttonStackView = UIStackView().setup { view in
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 16
    }
    
    private lazy var playView = CircleImageButtonView().setup { view in
        view.setView(backgroundColor: .backgroundButton, image: .playFill)
        let tap = UITapGestureRecognizer(target: self, action: #selector(playAndPauseClicked))
        view.addGestureRecognizer(tap)
    }
    
    private lazy var likeView = CircleImageButtonView().setup { view in
        view.setView(backgroundColor: .backgroundButton, image: .heart)
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeViewClicked))
        view.addGestureRecognizer(tap)
    }
    
    private lazy var shareView = CircleImageButtonView().setup { view in
        view.setView(backgroundColor: .backgroundButton, image: .share)
        let tap = UITapGestureRecognizer(target: self, action: #selector(shareViewClicked))
        view.addGestureRecognizer(tap)
    }
    
    private let titleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        view.textAlignment = .center
    }
    
    private let audioTitleLabel = UILabel().setup { view in
        view.textColor = .txtPrimary
        view.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        view.numberOfLines = 0
    }
    
    let audioSlider = AudioUISlider()
    
    let intervalTimeLabel = UILabel().setup { view in
        view.textColor = .txtSecondary
        view.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        view.text = "00:00"
    }
    
    private let playTimeLabel = UILabel().setup { view in
        view.textColor = .txtSecondary
        view.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
    }
    
    private let scriptLabel = UILabel().setup { view in
        view.textColor = .txtSecondary
        view.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        view.numberOfLines = 0
    }
    
    @objc private func playAndPauseClicked() {
        detailStoryProtocol?.playAndPauseClicked()
    }
    
    @objc private func likeViewClicked() {
        detailStoryProtocol?.likeViewClicked()
    }
    
    @objc private func shareViewClicked() {
        detailStoryProtocol?.shareViewClicked()
    }
    
    @objc private func backDetailStoryButtonClicked() {
        detailStoryProtocol?.backButtonClicked()
    }
    
    func fetchData(item: StoryItem) {
        titleLabel.text = item.title
        audioTitleLabel.text = item.audioTitle
        playTimeLabel.text = item.convertTime
        scriptLabel.text = item.script.replacingOccurrences(of: "  ", with: "\n\n")
        scriptLabel.setLineSpacing(spacing: 6)

        if item.imageURL.isEmpty {
            circleImageView.image = .defaultImg
            backBlurImageView.image = .defaultImg
        } else {
            if let url = URL(string: item.imageURL) {
                circleImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "default_img"),
                    options: [
                        .processor(DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))),
                        .scaleFactor(UIScreen.main.scale),
                        .cacheOriginalImage
                    ]
                )
                
                backBlurImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "default_img"),
                    options: [
                        .processor(DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))),
                        .scaleFactor(UIScreen.main.scale),
                        .cacheOriginalImage
                    ]
                )
            }
        }
    }
    
    func resetAudio() {
        audioSlider.value = 0
        intervalTimeLabel.text = "00:00"
        playView.setView(backgroundColor: .backgroundButton, image: .playFill)
    }
    
    func setPlayImageInAudio() {
        playView.setView(backgroundColor: .backgroundButton, image: .pauseFill)
    }
    
    func setLikeImage(isLike: Bool) {        
        let heartImage: UIImage = isLike == true ? .heartFill : .heart
        likeView.setView(backgroundColor: .backgroundButton, image: heartImage)
    }
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(imageContainerView)
        scrollView.addSubview(backBlurImageView)
        
        backBlurImageView.addSubview(blurredEffectView)
        addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(topView)
        vibrancyEffectView.contentView.addSubview(titleLabel)
        topView.addSubview(backButton)
        scrollView.addSubview(circleImageView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(audioSlider)
        containerView.addSubview(intervalTimeLabel)
        containerView.addSubview(playTimeLabel)
        
        containerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(playView)
        buttonStackView.addArrangedSubview(likeView)
        buttonStackView.addArrangedSubview(shareView)
        containerView.addSubview(audioTitleLabel)
        containerView.addSubview(scriptLabel)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self) // superview로 할 경우 horizontal scroll 영역 존재
            make.top.equalToSuperview()
            //            make.height.equalTo(imageContainerView.snp.width).multipliedBy(0.7)
            make.height.equalTo(300)
        }
        
        backBlurImageView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(imageContainerView)
            make.top.equalTo(self).priority(999)
            make.height.greaterThanOrEqualTo(imageContainerView.snp.height)
        }
        
        circleImageView.snp.makeConstraints { make in
            make.size.equalTo(160)
            make.bottom.equalTo(blurredEffectView).inset(54)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(circleImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(self).inset(30)
        }
        
        blurredEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        vibrancyEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom)
            make.horizontalEdges.equalTo(self)
            make.bottom.equalToSuperview()
//            make.height.equalTo(800)
        }
        
        audioSlider.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.horizontalEdges.equalTo(self).inset(40)
        }
        
        intervalTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(audioSlider.snp.bottom).offset(4)
            make.leading.equalTo(audioSlider)
        }
        
        playTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(audioSlider.snp.bottom).offset(4)
            make.trailing.equalTo(audioSlider)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(audioSlider.snp.bottom).offset(20)
            make.centerX.equalTo(self)
            make.height.equalTo(50)
        }
        
        playView.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        likeView.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        shareView.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        audioTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self).inset(20)
        }

        scriptLabel.snp.makeConstraints { make in
            make.top.equalTo(audioTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(audioTitleLabel)
            make.bottom.equalToSuperview().inset(40)
        }
    }
}
