//
//  HomeView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit
import SnapKit
import FSPagerView

final class HomeView: BaseView {
    
    var themes: [ThemeStory] = []
    
    private let contentView = UIView(frame: .zero)
    
    private lazy var pagerView = FSPagerView(frame: .zero).setup { view in
        let count: CGFloat = 1.2
        let spacing: CGFloat = 16
        view.register(HomePagerCollectionViewCell.self, forCellWithReuseIdentifier: HomePagerCollectionViewCell.identifier)
        let pagerItemWidth: CGFloat = UIScreen.main.bounds.width - (spacing * count)
        view.itemSize = CGSize(width: pagerItemWidth / count, height: (pagerItemWidth / count) * 2)
        //        view.isInfinite = true
        //        view.interitemSpacing = 10 // margin
        view.transformer = FSPagerViewTransformer(type: .linear)
        view.dataSource = self
        view.delegate = self
    }
    
    override func configureHierarchy() {
//        pagerView.backgroundColor = .purple
        addSubview(contentView)
        contentView.addSubview(pagerView)
    }
    
    override func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        pagerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}

extension HomeView: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return themes.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: HomePagerCollectionViewCell.identifier, at: index) as? HomePagerCollectionViewCell else {
            return FSPagerViewCell()
        }
        // 그림자 제거용
        cell.contentView.layer.shadowColor = UIColor.clear.cgColor
        cell.configCell(row: themes[index])
        return cell
    }
    
    // 아이템 클릭
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        print(#function, index)
        return false
    }
    
    // cell 자체 cornerRadius 조정
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
//        cell.clipsToBounds = true
//        cell.layer.cornerRadius = 10
    }
    
}
