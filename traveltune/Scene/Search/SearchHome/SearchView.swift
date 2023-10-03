//
//  SearchView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit
import IQKeyboardManagerSwift
import SnapKit

final class SearchView: BaseView {
    
    let recommendWords = ["이모티콘", "새싹", "추석", "고든램지", "햄버거", "피자", "긴긴긴1텍스트","긴긴긴2텍스트", "긴긴긴3텍스트", "긴긴긴4텍스트", "wow"]
    let recentSearchKeywords = ["감자", "고구마", "설날", "고깃덩어리", "햄", "국자", "1텍스트","2텍스트", "3텍스트", "4텍스트", "wow???"]
    
    weak var searchVCProtocol: SearchVCProtocol?
    
    lazy var naviBarSearchTextField = SearchTextField().setup { view in
        let width = UIScreen.main.bounds.width - 80
        view.frame = .init(x: 0, y: 0, width: width, height: 40)
        view.returnKeyType = .search
        view.addDoneOnKeyboardWithTarget(self, action: #selector(toolBarDoneClicked), titleText: nil)
        //        view.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(keyboardDoneClicked))
        view.delegate = self
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).setup { view in
        view.showsVerticalScrollIndicator = false
        view.delegate = self
    }
    
    var dataSource: UICollectionViewDiffableDataSource<SearchController.Section, SearchController.Item>!
    
    @objc private func toolBarDoneClicked() {
        naviBarSearchTextField.resignFirstResponder()
    }
    
    override func configureHierarchy() {
        addSubview(collectionView)
        configureDataSource()
        configureSnapShot(recommendItems: recommendWords, recentItems: nil)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        let headerRegistration = createHeaderRegistration()
        let recommendRegistration = createRecommendCellRegistration()
        let recentSearchKeywordRegistration = createRecentSearchCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<SearchController.Section, SearchController.Item>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = SearchController.Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .recommend:
                return collectionView.dequeueConfiguredReusableCell(using: recommendRegistration, for: indexPath, item: item)
            case .recentSearchKeyword:
                return collectionView.dequeueConfiguredReusableCell(using: recentSearchKeywordRegistration, for: indexPath, item: item)
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }
    }
    
    func configureSnapShot(recommendItems: [String]? = nil, recentItems: [String]? = nil) {
        let sections = SearchController.Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<SearchController.Section, SearchController.Item>()
        
        let recommendList = recommendItems?.map { SearchController.Item(recommendItem: SearchController.RecommendItem(title: $0)) }
        let recentList = recentItems?.map { SearchController.Item(recentSearchItem: SearchController.RecentSearchItem(keyword: $0)) }
        
        sections.forEach { section in
            switch section {
            case .recommend:
                if let recommendList {
                    snapshot.appendSections([section])
                    snapshot.appendItems(recommendList, toSection: section)
                }
            case .recentSearchKeyword:
                if let recentList {
                    snapshot.appendSections([section])
                    snapshot.appendItems(recentList, toSection: section)
                }
            }
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchVCProtocol?.textfieldDoneClicked(searchText: textField.text ?? "")
        return true
    }
}

extension SearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let recommendItem = self.dataSource.itemIdentifier(for: indexPath)?.recommendItem {
            searchVCProtocol?.recommendWordClicked(searchText: recommendItem.title)
        }
        
        if let recentSearchItem = self.dataSource.itemIdentifier(for: indexPath)?.recentSearchItem {
            searchVCProtocol?.recentWordClicked(searchText: recentSearchItem.keyword)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        naviBarSearchTextField.resignFirstResponder()
    }
}

extension SearchView {
    
    private func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<TitleSupplementaryView> {
        return UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: SearchController.sectionHeaderElementKind) {
            (supplementaryView, string, indexPath) in
            supplementaryView.titleLabel.text = SearchController.Section(rawValue: indexPath.section)?.description
        }
    }
    
    private func createRecommendCellRegistration() -> UICollectionView.CellRegistration<SearchTagCell, SearchController.Item> {
        return UICollectionView.CellRegistration<SearchTagCell, SearchController.Item> { (cell, indexPath, identifier) in
            //            var background = UIBackgroundConfiguration.listPlainCell()
            //            background.cornerRadius = 8
            //            background.strokeColor = .systemGray3
            //            background.strokeWidth = 1.0 / cell.traitCollection.displayScale
            //            cell.backgroundConfiguration = background
            if let recommendItem = identifier.recommendItem {
                cell.configCell(row: recommendItem.title)
            }
        }
    }
    
    private func createRecentSearchCellRegistration() -> UICollectionView.CellRegistration<SearchRecentWordCell, SearchController.Item> {
        return UICollectionView.CellRegistration<SearchRecentWordCell, SearchController.Item> { (cell, indexPath, identifier) in
            if let recentSearchItem = identifier.recentSearchItem {
                cell.deleteClicked = { [weak self] in
                    self?.searchVCProtocol?.deleteRecentWordClicked()
                }
                cell.configCell(row: recentSearchItem.keyword)
            }
        }
    }
    
    private func recommendSection() -> NSCollectionLayoutSection {
        let spacing: CGFloat = 10
        let section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10) // 그룹 내 아이템 간의 간격
        group.edgeSpacing = .init(leading: .fixed(16), top: .fixed(0), trailing: .fixed(16), bottom: .fixed(0)) // 그룹 spacing
        
        section = NSCollectionLayoutSection(group: group)
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: SearchController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        return section
    }
    
    private func recentSearchKeywordSection() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //        group.interItemSpacing = .fixed(50)
        group.edgeSpacing = .init(leading: .fixed(16), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(0)) // 그룹 spacing
        
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: SearchController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = SearchController.Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            switch sectionKind {
            case .recommend:
                section = self.recommendSection()
            case .recentSearchKeyword:
                section = self.recentSearchKeywordSection()
            }
            return section
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .vertical
        configuration.interSectionSpacing = 20 // 섹션간 스페이싱
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        layout.configuration = configuration
        return layout
    }
}
