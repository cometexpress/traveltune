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
    
    @objc private func backDetailStoryButtonClicked() {
        detailStoryProtocol?.backButtonClicked()
    }
    
    func fetchData(item: StoryItem) {
        
//        titleLabel.text = item.title
//        addrLabel.text = item.fullAddr
//        categoryLabel.isHidden = item.themeCategory.isEmpty
//        categoryLabel.text = "#\(item.themeCategory)"

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
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(imageContainerView)
        scrollView.addSubview(backBlurImageView)
        
        backBlurImageView.addSubview(blurredEffectView)
        addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(topView)
        topView.addSubview(backButton)
        scrollView.addSubview(circleImageView)
        
        scrollView.addSubview(containerView)
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
            make.height.equalTo(600)
        }
    }
}
