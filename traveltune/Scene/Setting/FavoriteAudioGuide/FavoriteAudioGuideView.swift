//
//  FavoriteAudioGuideView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/16.
//

import UIKit
import SnapKit

final class FavoriteAudioGuideView: BaseView {
    
    weak var favoriteAudioGuideProtocol: FavoriteAudioGuideVCProtocol?
    
    var favoriteStories: [FavoriteStory] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let topView = UIView()
    private let guideCountLabel = UILabel().setup { view in
        view.textColor = .txtPrimary
        view.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        view.text = Strings.Common.story
    }
    
    let emptyLabel = UILabel().setup { view in
        view.textColor = .txtDisabled
        view.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
        view.text = Strings.Common.favoriteStoryNoData
        view.textAlignment = .center
        view.isHidden = true
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
    
    lazy var scriptView = StoryScriptView().setup { view in
        view.closeClicked = {
            self.hideScriptView()
        }
    }
    
    func updateCountLabel(count: Int) {
        countLabel.text = "\(count)"
    }
    
    func showEmptyLabel() {
        topView.isHidden = true
        collectionView.isHidden = true
        playerBottomView.isHidden = true
        emptyLabel.isHidden = false
    }
    
    func showScriptView() {
        playerBottomView.thumbImageView.isUserInteractionEnabled = false
        scriptView.isHidden = false
        scriptView.isUserInteractionEnabled = false
        scriptView.snp.remakeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(playerBottomView.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
        scriptView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut) {
            self.scriptView.alpha = 1
            self.layoutIfNeeded()
        } completion: { _ in
            self.scriptView.isUserInteractionEnabled = true
        }

    }
    
    func hideScriptView() {
        scriptView.isUserInteractionEnabled = false
        scriptView.snp.remakeConstraints { make in
            make.top.equalTo(playerBottomView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        scriptView.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.layoutIfNeeded()
            self.scriptView.alpha = 0
        } completion: { _ in
            self.scriptView.isHidden = true
            self.playerBottomView.thumbImageView.isUserInteractionEnabled = true
        }
    }
    
    override func configureHierarchy() {
        addSubview(topView)
        topView.addSubview(guideCountLabel)
        topView.addSubview(countLabel)
        addSubview(collectionView)
        addSubview(playerBottomView)
        addSubview(scriptView)
        addSubview(emptyLabel)
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
        
        scriptView.snp.makeConstraints { make in
            make.top.equalTo(playerBottomView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
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
        cell.heartButtonClicked = { [weak self] in
            self?.favoriteAudioGuideProtocol?.cellHeartButtonClicked(item: item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = favoriteStories[indexPath.item]
        favoriteAudioGuideProtocol?.didSelectItemAt(item: item)
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
