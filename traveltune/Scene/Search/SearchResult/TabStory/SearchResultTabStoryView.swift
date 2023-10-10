//
//  SearchResultTabStoryView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit
import SnapKit

final class SearchResultTabStoryView: BaseView {
    
    weak var viewModel: SearchResultTabStoryViewModel?
    weak var searchResultTabStoryVCProtocol: SearchResultTabStoryVCProtocol?
    
    var storyItems: [StoryItem] = []
    
    var page = 1
    
    enum Section {
        case main
    }
    
    lazy var dataSource: UICollectionViewDiffableDataSource<Section, StoryItem>! = nil
    
    let emptyLabel = UILabel().setup { view in
        view.textColor = .txtDisabled
        view.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
        view.text = Strings.Common.searchNoData
        view.textAlignment = .center
        view.isHidden = true
    }
    
    // 데이터 있을 때
    let containerView = UIView().setup { view in
        view.isHidden = true
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).setup { view in
        view.delegate = self
    }
    
    private let loadingView = UIView().setup { view in
        view.isUserInteractionEnabled = false
    }
    
    private let indicatorView = UIActivityIndicatorView(style: .large).setup { view in
        view.color = .primary
        view.startAnimating()
    }
    
    func showLoading() {
        loadingView.isHidden = false
    }
    
    func hideLoading() {
        loadingView.isHidden = true
    }
    
    override func configureHierarchy() {
        addSubview(containerView)
        containerView.addSubview(collectionView)
        addSubview(emptyLabel)
        addSubview(loadingView)
        loadingView.addSubview(indicatorView)
        configureDataSource()
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        loadingView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension SearchResultTabStoryView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
        collectionView.deselectItem(at: indexPath, animated: true)
        searchResultTabStoryVCProtocol?.didSelectItemAt(item: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel else { return }
        if !viewModel.isLoading && viewModel.totalPage > page {
            if dataSource.snapshot().numberOfSections - 1 == indexPath.section {
                let currentSection = dataSource.snapshot().sectionIdentifiers[indexPath.section]
                if dataSource.snapshot().numberOfItems(inSection: currentSection) - 1 == indexPath.item {
                    page += 1
                    searchResultTabStoryVCProtocol?.willDisplay(page: page)
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchResultTabStoryVCProtocol?.scrollBeginDragging()
    }
}

extension SearchResultTabStoryView {
    
    func applySnapShot(items: [StoryItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, StoryItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createCellRegistration() -> UICollectionView.CellRegistration<SearchResultStoryCell, StoryItem> {
        return UICollectionView.CellRegistration<SearchResultStoryCell, StoryItem> { (cell, indexPath, identifier) in
            cell.configCell(row: identifier)
        }
    }
    
    private func configureDataSource() {
        let storyRegistration = createCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, StoryItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: StoryItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: storyRegistration, for: indexPath, item: identifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, StoryItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems([])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let spacing: CGFloat = 10
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
