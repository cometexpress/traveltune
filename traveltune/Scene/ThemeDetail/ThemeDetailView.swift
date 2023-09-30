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
        
    weak var viewModel: ThemeDetailViewModel?
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
    private let emptyTopView = UIView()
    
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
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: self.collectionViewLayout()
    ).setup { view in
        view.showsVerticalScrollIndicator = false
        view.register(ThemeDetailCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ThemeDetailCollectionHeaderView.identifier)
        view.register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.isHidden = true
    }
    
    @objc private func buttonClicked(_ sender: UIButton) {
        switch sender {
        case backButton:
            themeDetailVCProtocol?.backButtonClicked()
        case infoButton:
            themeDetailVCProtocol?.infoButtonClicked()
        default: print(#function)
        }
    }
    
    private let topViewHeight = 50
    
    override func configureHierarchy() {
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(blurredEffectView)
        addSubview(emptyTopView)
        addSubview(vibrancyEffectView)
        vibrancyEffectView.contentView.addSubview(topView)
        topView.addSubview(topTitleLabel)
        topView.addSubview(backButton)
        topView.addSubview(infoButton)
        
        addSubview(collectionView)
//        vibrancyEffectView.contentView.addSubview(collectionView)
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
            make.height.equalTo(topViewHeight)
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
        
        emptyTopView.snp.makeConstraints { make in
            make.height.equalTo(topViewHeight)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(emptyTopView.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(10)
        }

    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let width: CGFloat = UIScreen.main.bounds.width
        let headerHeight: CGFloat = UIScreen.main.bounds.height / 3.1
        return UICollectionViewFlowLayout().collectionViewLayout(
            headerSize: CGSize(width: width, height: headerHeight),
            itemSize: CGSize(width: width, height: 60),
//            itemSize: CGSize(width: width, height: headerHeight / 3.4),
            sectionInset: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0),
            minimumLineSpacing: 2,
            minimumInteritemSpacing: 0)
    }
}

extension ThemeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.stories.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCell.identifier, for: indexPath) as? StoryCell,
              let row = viewModel?.stories.value[indexPath.item] else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .cyan
        cell.configCell(row: row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ThemeDetailCollectionHeaderView.identifier, for: indexPath) as? ThemeDetailCollectionHeaderView else {
                return UICollectionReusableView()
            }
            
            headerView.previousClicked = { [weak self] in
                self?.themeDetailVCProtocol?.previousButtonClicked()
            }
            
            headerView.nextClicked = { [weak self] in
                self?.themeDetailVCProtocol?.nextButtonClicked()
            }
            
            headerView.playAndPauseClicked = { [weak self] in
                self?.themeDetailVCProtocol?.playAndPauseButtonClicked()
            }
                    
            if let item = viewModel?.stories.value.first {
                headerView.configView(item: item)
            }
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }    
}
