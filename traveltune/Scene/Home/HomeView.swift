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
    
    var list: [String] = ["1번 제목", "2번 제목", "3번 제목", "4번 제목", "5번 제목", "6번 제목"]
    
    private let guideLabel = UILabel().setup { view in
        view.text = "어디로 떠나볼까요?"
        view.textColor = .txtPrimary
        view.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
    }
    
    private let contentView = UIView(frame: .zero)
    
    private lazy var pagerView = FSPagerView(frame: .zero).setup { view in
        let count: CGFloat = 1.6
        let spacing: CGFloat = 16
        view.register(HomePagerCollectionViewCell.self, forCellWithReuseIdentifier: HomePagerCollectionViewCell.identifier)
        //        view.itemSize = FSPagerView.automaticSize
        let pagerItemWidth: CGFloat = UIScreen.main.bounds.width - (spacing * count)
        // view.itemSize 에서 height 는 양 사이드에 있는 아이템의 높이
        view.itemSize = CGSize(width: pagerItemWidth / count, height: (pagerItemWidth / count) * count)
        //        view.isInfinite = true
        view.backgroundColor = .link
        //        view.interitemSpacing = 10 // margin
        view.transformer = FSPagerViewTransformer(type: .linear)
        view.dataSource = self
        view.delegate = self
    }
    
    override func configureHierarchy() {
        addSubview(guideLabel)
        addSubview(contentView)
        contentView.addSubview(pagerView)
    }
    
    override func configureLayout() {
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        contentView.backgroundColor = .orange
        contentView.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        pagerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
    }
}

extension HomeView: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return list.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: HomePagerCollectionViewCell.identifier, at: index) as? HomePagerCollectionViewCell else {
            return FSPagerViewCell()
        }
        cell.configCell(row: list[index])
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
        cell.layer.cornerRadius = 10
    }
    
}
