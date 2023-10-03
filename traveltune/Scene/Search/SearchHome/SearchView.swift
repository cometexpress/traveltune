//
//  SearchView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit
import SnapKit

//struct Item: Hashable {
//    private let identifier = UUID()
//    let sectionTitle: String?
//    let recommendItem: RecommendItem?
//    let recentSearchItem: RecentSearchItem?
//
//    init(sectionTitle: String? = nil, recommendItem: RecommendItem? = nil, recentSearchItem: RecentSearchItem? = nil) {
//        self.sectionTitle = sectionTitle
//        self.recommendItem = recommendItem
//        self.recentSearchItem = recentSearchItem
//    }
//}

final class SearchView: BaseView {
    
    enum Section: Int, Hashable, CaseIterable {
        case recommend, recentSearchKeyword
        var description: String {
            switch self {
            case .recommend: return "추천 검색어"
            case .recentSearchKeyword: return "최근 검색어"
            }
        }
    }
    
    let strList = ["이모티콘", "새싹", "추석", "고든램지", "햄버거", "피자", "긴긴긴1텍스트","긴긴긴2텍스트", "긴긴긴3텍스트", "긴긴긴4텍스트", "wow"]
    let strList22 = ["감자", "고구마", "설날", "고깃덩어리", "햄", "국자", "1텍스트","2텍스트", "3텍스트", "4텍스트", "wow???"]
    
    let naviBarSearchTextField = SearchTextField().setup { view in
        let width = UIScreen.main.bounds.width - 80
        view.frame = .init(x: 0, y: 0, width: width, height: 40)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).setup { view in
        view.delegate = self
    }
    
    //    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    override func configureHierarchy() {
        addSubview(collectionView)
        headerConfigureDataSource()
        
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func createHeaderRegistration() -> UICollectionView.SupplementaryRegistration<TitleSupplementaryView> {
        return UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: SearchController.sectionHeaderElementKind) {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = Section(rawValue: indexPath.section)?.description
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
    }
    
    private func createRecommendCellRegistration() -> UICollectionView.CellRegistration<ListCell, String> {
        return UICollectionView.CellRegistration<ListCell, String> { (cell, indexPath, identifier) in
            cell.label.text = identifier
        }
    }
    
    private func createRecentSearchCellRegistration() -> UICollectionView.CellRegistration<ListCell, String> {
        return UICollectionView.CellRegistration<ListCell, String> { (cell, indexPath, identifier) in
            cell.label.text = identifier
        }
    }
    
    private func headerConfigureDataSource() {
        
        let headerRegistration = createHeaderRegistration()
        let recommendRegistration = createRecommendCellRegistration()
        let recentSearchKeywordRegistration = createRecentSearchCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
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
        
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        var recommendList = strList
        var recentList = strList22
        
        sections.forEach { section in
            snapshot.appendSections([section])
            switch section {
            case .recommend:
                snapshot.appendItems(recommendList, toSection: section)
            case .recentSearchKeyword:
                snapshot.appendItems(recentList, toSection: section)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    private func recommendSection() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        let spacing: CGFloat = 10
        section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: SearchController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func recentSearchKeywordSection() -> NSCollectionLayoutSection {
        let section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: SearchController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            switch sectionKind {
            case .recommend:
                section = self.recommendSection()
            case .recentSearchKeyword:
                section = self.recentSearchKeywordSection()
            }
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

extension SearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
