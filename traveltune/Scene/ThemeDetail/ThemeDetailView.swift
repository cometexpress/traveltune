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
    
    let backgroundImageView = UIImageView().setup { view in
        view.hero.id = Constant.HeroID.themeThumnail
        view.contentMode = .scaleAspectFill
    }
    
    private let opacityView = UIView().setup { view in
        view.hero.id = Constant.HeroID.themeOpacity
        view.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    let topView = UIView()
    
    let topTitleLabel = UILabel().setup { view in
        view.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
        view.textColor = .white
        view.textAlignment = .center
    }
    
    lazy var backButton = UIButton().setup { view in
        view.setImage(.backCircle.withTintColor(.white), for: .normal)
        view.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    lazy var shareButton = UIButton().setup { view in
        view.setImage(.share.withTintColor(.white), for: .normal)
        view.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.collectionViewLayout()
    )
    
    private let playView = UIView().setup { view in
//        view.backgroundColor = .purple
    }
    
    @objc private func buttonClicked(_ sender: UIButton) {
        switch sender {
        case backButton:
            themeDetailVCProtocol?.backButtonClicked()
        case shareButton:
            themeDetailVCProtocol?.shareButtonClicked()
        default: print(#function)
        }
    }
    
    override func configureHierarchy() {
        addSubview(backgroundImageView)
        addSubview(opacityView)
        addSubview(topView)
        topView.addSubview(topTitleLabel)
        topView.addSubview(backButton)
        topView.addSubview(shareButton)
        addSubview(collectionView)
        addSubview(playView)
    }
    
    override func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        opacityView.snp.makeConstraints { make in
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
            make.trailing.equalTo(shareButton.snp.leading).offset(-8)
        }
        
        shareButton.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
//        collectionView.backgroundColor = .primary
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(playView.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        
        playView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
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
