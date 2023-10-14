//
//  DetailMapSpotView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/11.
//

import UIKit
import SnapKit

final class DetailMapSpotView: BaseView {
    
    weak var viewModel: DetailMapSpotViewModel?
    weak var detailMapSpotVCProtocol: DetailMapSpotVCProtocol?
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).setup { view in
        view.contentInsetAdjustmentBehavior = .never
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.identifier)
        view.register(
            DetailMapSpotHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailMapSpotHeaderView.identifier
        )
    }
    
    override func configureHierarchy() {
        addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
}

extension DetailMapSpotView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.mapSpotItem?.stories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCell.identifier, for: indexPath) as? StoryCell else {
            return UICollectionViewCell()
        }
        if let item = viewModel?.mapSpotItem?.stories[indexPath.item] {
            cell.configCell(row: item)
            cell.heartButtonClicked = { [weak self] in
                self?.detailMapSpotVCProtocol?.cellHeartButtonClicked(item: item)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailMapSpotHeaderView.identifier, for: indexPath) as? DetailMapSpotHeaderView else { return UICollectionReusableView() }
            
            if let item = viewModel?.mapSpotItem {
                view.configCell(row: item)
            }
            
            view.backClicked = { [weak self] in
                self?.detailMapSpotVCProtocol?.backClicked()
            }
            
            view.moveMapClicked = { [weak self] in
                self?.detailMapSpotVCProtocol?.moveMapClicked()
            }
            
            return view
            
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = viewModel?.mapSpotItem?.stories[indexPath.item] else { return }
        detailMapSpotVCProtocol?.didSelectItemAt(item: item)
    }
}

extension DetailMapSpotView {
    
    func createLayout() -> UICollectionViewLayout {
        // 비율 계산해서 디바이스 별로 UI 설정
        let layout = StretchableUICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width: CGFloat = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: width, height: 60)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)  // 컨텐츠가 잘리지 않고 자연스럽게 표시되도록 여백설정
        layout.minimumLineSpacing = spacing         // 셀과셀 위 아래 최소 간격
        layout.minimumInteritemSpacing = spacing    // 셀과셀 좌 우 최소 간격
        layout.headerReferenceSize = CGSize(width: width, height: width)
        return layout
    }
    
}
