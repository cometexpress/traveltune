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
    
    private lazy var pagerView = FSPagerView(frame: .zero).setup { view in
        let count: CGFloat = 1.3
        let spacing: CGFloat = 10
        view.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "pagerCell")
//        view.itemSize = FSPagerView.automaticSize
        let pagerItemWidth: CGFloat = UIScreen.main.bounds.width - (spacing * count)
        // view.itemSize 에서 height 는 양 사이드에 있는 아이템의 높이
        
        print("height = ", (pagerItemWidth / count) * 1.5)
        
        view.itemSize = CGSize(width: pagerItemWidth / count, height: (pagerItemWidth / count) * 1.5)
        view.isInfinite = true
       
//        view.interitemSpacing = 10 // margin
        view.transformer = FSPagerViewTransformer(type: .linear)
        view.dataSource = self
        view.delegate = self
    }
    
    override func configureHierarchy() {
        addSubview(pagerView)
    }
    
    override func configureLayout() {
        pagerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
}

extension HomeView: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 7
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "pagerCell", at: index)
        cell.backgroundColor = .primary
        cell.imageView?.image = UIImage(systemName: "star")
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }
    
    // 아이템 클릭
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        print(#function, index)
        return false
    }
    
    // cornerRadius 조정
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
    }
    
}
