//
//  FavoriteAudioGuideView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/16.
//

import UIKit
import SnapKit

final class FavoriteAudioGuideView: BaseView {
    
    var favoriteStories: [FavoriteStory] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let topView = UIView()
    private let guideCountLabel = UILabel().setup { view in
        view.textColor = .txtPrimary
        view.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        view.text = "이야기"
    }
    
    private let countLabel = UILabel().setup { view in
        view.textColor = .primary
        view.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).setup { view in
        view.register(FavoriteStoryCell.self, forCellWithReuseIdentifier: FavoriteStoryCell.identifier)
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
    }
    
    let playerBottomView = PlayerBottomView()
    
    func updateCountLabel(count: Int) {
        countLabel.text = "\(count)"
    }
    
    override func configureHierarchy() {
        addSubview(topView)
        topView.addSubview(guideCountLabel)
        topView.addSubview(countLabel)
        addSubview(collectionView)
        addSubview(playerBottomView)
    }
    
    override func configureLayout() {
        topView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        guideCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(guideCountLabel.snp.trailing).offset(6)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(playerBottomView.snp.top)
        }
        
        playerBottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(self.snp.height).multipliedBy(0.13)
        }
    }
}

extension FavoriteAudioGuideView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteStoryCell.identifier, for: indexPath) as? FavoriteStoryCell else {
            return UICollectionViewCell()
        }
        let item = favoriteStories[indexPath.item]
        cell.configCell(row: item)
        return cell
    }

}

extension FavoriteAudioGuideView {
    
    private func createLayout() -> UICollectionViewLayout {
        let width: CGFloat = UIScreen.main.bounds.width
        let spacing: CGFloat = 8
        return UICollectionViewFlowLayout().collectionViewLayout(
            headerSize: .zero,
            itemSize: CGSize(width: width, height: 60),
            sectionInset: UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing),
            minimumLineSpacing: 2,
            minimumInteritemSpacing: 0)
    }
}
