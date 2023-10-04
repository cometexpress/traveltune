//
//  SearchResultView.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit
import SnapKit
import Parchment

final class SearchResultView: BaseView {
    
    lazy var naviBarSearchTextField = SearchTextField().setup { view in
        let width = UIScreen.main.bounds.width - 80
        view.frame = .init(x: 0, y: 0, width: width, height: 40)
        view.delegate = self
    }
    
    lazy var commonTabPaingVC = CommonTabPagingVC(
        viewControllers: [SearchResultTabTravelSpotVC(), SearchResultTabStoryVC()],
        tabTitles: [Strings.SearchTabTitle.TravelSpot, Strings.SearchTabTitle.Story]
    )
    
    override func configureHierarchy() {
        commonTabPaingVC.dataSource = self
        //        commonTabPaingVC.sizeDelegate = self
        addSubview(commonTabPaingVC.view)
    }
    
    override func configureLayout() {
        commonTabPaingVC.view.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension SearchResultView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchVCProtocol?.textfieldDoneClicked(searchText: textField.text ?? "")
        return true
    }
}

extension SearchResultView: PagingViewControllerDataSource {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return commonTabPaingVC.tabTitles.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return commonTabPaingVC.tabViewControllers[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: commonTabPaingVC.tabTitles[index])
    }
}

