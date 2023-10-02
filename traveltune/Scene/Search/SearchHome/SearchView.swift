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
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.headerCreateLayout()).setup { view in
        view.delegate = self
    }
    
    //    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    override func configureHierarchy() {
        addSubview(collectionView)
        //        configureDataSource()
        //        applyInitialSnapshots()
        headerConfigureDataSource()
        
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func createHeaderRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, sectionTitle) in
            var content = cell.defaultContentConfiguration()
            content.text = sectionTitle
            cell.contentConfiguration = content
            //            cell.accessories = [.outlineDisclosure()]
        }
    }
    
    //    func createHeaderRegistration22() -> UICollectionView.SupplementaryRegistration<UICollectionViewListCell> {
    //        return UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
    //            var configutation = UIListContentConfiguration.groupedHeader()
    //            configutation.text = Section.allCases[indexPath.section].rawValue.description
    //            configutation.textProperties.color = .systemBrown
    //            supplementaryView.contentConfiguration = configutation
    //        }
    //    }
    
    //    func createRecommendCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, RecommendItem> {
    //        return UICollectionView.CellRegistration<UICollectionViewCell, RecommendItem> { (cell, indexPath, recommendItem) in
    //            var content = UIListContentConfiguration.cell()
    //            content.text = recommendItem.title
    //            content.textProperties.font = .boldSystemFont(ofSize: 38)
    //            content.textProperties.alignment = .center
    //            content.directionalLayoutMargins = .zero
    //            cell.contentConfiguration = content
    //            var background = UIBackgroundConfiguration.listPlainCell()
    //            background.cornerRadius = 8
    //            background.strokeColor = .systemGray3
    //            background.strokeWidth = 1.0 / cell.traitCollection.displayScale
    //            cell.backgroundConfiguration = background
    //        }
    //    }
    
    //    func createRecentSearchCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, RecentSearchItem> {
    //        return UICollectionView.CellRegistration<UICollectionViewCell, RecentSearchItem> { (cell, indexPath, recentSearchItem) in
    //            var content = UIListContentConfiguration.cell()
    //            content.text = recentSearchItem.keyword
    //            cell.contentConfiguration = content
    //        }
    //    }
    
    func headerConfigureDataSource() {
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: SearchController.sectionHeaderElementKind) {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = Section(rawValue: indexPath.section)?.description
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
        
        let cellRegistration = UICollectionView.CellRegistration<ListCell, String> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.label.text = identifier
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }
    
        // initial data
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        //        var itemOffset = 0
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
            
            //            snapshot.appendItems(Array(itemOffset..<itemOffset + itemsPerSection))
            //            itemOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    //    func configureDataSource() {
    //        let headerRegistration = createHeaderRegistration()
    //        let recommendRegistration = createRecommendCellRegistration()
    //        let recentSearchKeywordRegistration = createRecentSearchCellRegistration()
    //
    //        // data source
    //        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
    //            (collectionView, indexPath, item) -> UICollectionViewCell? in
    //            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
    //            switch section {
    //            case .recommend:
    //                return if indexPath.item == 0 {
    //                    collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item.sectionTitle)
    //                } else {
    //                    collectionView.dequeueConfiguredReusableCell(using: recommendRegistration, for: indexPath, item: item.recommendItem)
    //                }
    //
    //            case .recentSearchKeyword:
    //                return if indexPath.item == 0 {
    //                    collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item.sectionTitle)
    //                } else {
    //                    collectionView.dequeueConfiguredReusableCell(using: recentSearchKeywordRegistration, for: indexPath, item: item.recentSearchItem)
    //                }
    //            }
    //        }
    //    }
    
    //        func applyInitialSnapshots() {
    //            let sections = Section.allCases
    //            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    //            snapshot.appendSections(sections)
    //            dataSource.apply(snapshot, animatingDifferences: false)
    //
    //            // 추천 검색어
    //            let recommendItems = strList.map { Item(recommendItem: RecommendItem(title: $0)) }
    //            //        var recommendSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
    //            //        recommendSnapshot.append(recommendItems)
    //            //        dataSource.apply(recommendSnapshot, to: .recommend, animatingDifferences: false)
    //
    //            // 최근 검색어
    //            let recentSearchKeywordItems = strList22.map { Item(recentSearchItem: RecentSearchItem(keyword: $0)) }
    //            //        var recentSearchKeywordSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
    //            //        recentSearchKeywordSnapshot.append(recentSearchKeywordItems)
    //            //        dataSource.apply(recentSearchKeywordSnapshot, to: .recentSearchKeyword, animatingDifferences: false)
    //
    //            for section in sections {
    //                var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
    //                let headerItem = Item(sectionTitle: section.description)
    //                sectionSnapshot.append([headerItem])
    //
    //                switch section {
    //                case .recommend:
    //                    sectionSnapshot.append(recommendItems, to: headerItem)
    //                    sectionSnapshot.expand([headerItem])
    //                    dataSource.apply(sectionSnapshot, to: section)
    //                case .recentSearchKeyword:
    //                    sectionSnapshot.append(recentSearchKeywordItems, to: headerItem)
    //                    sectionSnapshot.expand([headerItem])
    //                    dataSource.apply(sectionSnapshot, to: section)
    //                }
    //            }
    //        }
    
    func headerCreateLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .recommend:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.interItemSpacing = .fixed(10)
                let spacing: CGFloat = 10
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
                section.interGroupSpacing = spacing
                
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                              heightDimension: .estimated(44))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: SearchController.sectionHeaderElementKind, alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
                
//                let configuration = UICollectionViewCompositionalLayoutConfiguration()
//                configuration.scrollDirection = .vertical
//                let layout = UICollectionViewCompositionalLayout(section: section)
//                layout.configuration = configuration
                
            case .recentSearchKeyword:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(44))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 5
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
                
                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                              heightDimension: .estimated(44))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: SearchController.sectionHeaderElementKind, alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
            }
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        
    }
    
//    private func createLayout() -> UICollectionViewLayout {
//        
//        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//            
//            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
//            
//            let section: NSCollectionLayoutSection
//            
//            switch sectionKind {
//            case .recommend:
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28), heightDimension: .fractionalWidth(0.2))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                section = NSCollectionLayoutSection(group: group)
//                section.interGroupSpacing = 10
//                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//            case .recentSearchKeyword:
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                      heightDimension: .fractionalHeight(1.0))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(44))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                section = NSCollectionLayoutSection(group: group)
//                section.interGroupSpacing = 20
//                section.contentInsets = NSDirectionalEdgeInsets(top: 100, leading: 10, bottom: 0, trailing: 10)
//                let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(44))
//                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: headerFooterSize,
//                    elementKind: SearchController.sectionHeaderElementKind, alignment: .top)
//                section.boundarySupplementaryItems = [sectionHeader]
//            }
//            
//            return section
//        }
//        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
//    }
}

extension SearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
