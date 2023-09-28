//
//  ThemeDetailView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit
import Hero
import SnapKit

final class ThemeDetailView: BaseView {
    
    weak var themeDetailVCProtocol: ThemeDetailVCProtocol?
    
    private let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let vibrancyEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .regular)))
    
    let backgroundImageView = UIImageView().setup { view in
        view.contentMode = .scaleAspectFill
        view.hero.id = Constant.HeroID.themeThumnail
    }
    
    private let opacityView = UIView().setup { view in
        view.hero.id = Constant.HeroID.themeOpacity
        view.backgroundColor = .translucent
    }
    
    let topView = UIView()
    
    lazy var topTitleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
    }
    
    lazy var backButton = UIButton().setup { view in
        view.setImage(.backCircle.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        view.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    lazy var infoButton = UIButton().setup { view in
        view.setImage(.infoCircle.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        view.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.collectionViewLayout()
    )
    
    @objc private func buttonClicked(_ sender: UIButton) {
        switch sender {
        case backButton:
            themeDetailVCProtocol?.backButtonClicked()
        case infoButton:
            themeDetailVCProtocol?.infoButtonClicked()
        default: print(#function)
        }
    }
    
    override func configureHierarchy() {
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(blurredEffectView)
        
        addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(topView)
        vibrancyEffectView.contentView.addSubview(collectionView)
        topView.addSubview(topTitleLabel)
        topView.addSubview(backButton)
        topView.addSubview(infoButton)
    }
    
    override func configureLayout() {
        
        blurredEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        vibrancyEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        topTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(backButton.snp.trailing).offset(8)
            make.trailing.equalTo(infoButton.snp.leading).offset(-8)
        }
        
        infoButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let width: CGFloat = UIScreen.main.bounds.width
        return UICollectionViewFlowLayout().collectionViewLayout(
            itemSize: CGSize(width: width, height: 50),
            sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            minimumLineSpacing: 0,
            minimumInteritemSpacing: 0)
    }
}
