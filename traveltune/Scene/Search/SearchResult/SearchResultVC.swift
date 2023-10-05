//
//  SearchResultVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit
import Parchment
import SnapKit

final class SearchResultVC: UIViewController {
    
    var searchKeyword: String?
    
    private var viewModel = SearchResultViewModel()
    
    private var tabTravelSpotViewModel = SearchResultTabTravelSpotViewModel()
    private var tabStoryViewModel = SearchResultTabStoryViewModel()
    
    private var commonTabPaingVC = CommonTabPagingVC()
    
    private lazy var naviBarSearchTextField = SearchTextField().setup { view in
        let width = UIScreen.main.bounds.width - 80
        view.frame = .init(x: 0, y: 0, width: width, height: 40)
        view.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        // 최초 검색키워드 전달을 위해 이때 초기화
        commonTabPaingVC = CommonTabPagingVC(
            viewControllers: [
                SearchResultTabTravelSpotVC(keyword: searchKeyword),
                SearchResultTabStoryVC(viewModel: tabStoryViewModel)
            ],
            tabTitles: [Strings.SearchTabTitle.TravelSpot, Strings.SearchTabTitle.Story]
        )
        
        configureHierarchy()
        configureLayout()
        configureVC()
    }
    
    private func configureHierarchy() {
        commonTabPaingVC.dataSource = self
        //        commonTabPaingVC.sizeDelegate = self
        view.addSubview(commonTabPaingVC.view)
    }
    
    private func configureLayout() {
        commonTabPaingVC.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configureVC() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        naviBarSearchTextField.text = searchKeyword
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        navigationItem.titleView = naviBarSearchTextField
        
        addChild(commonTabPaingVC)
        commonTabPaingVC.didMove(toParent: self)
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchResultVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let selectedVC = commonTabPaingVC.state.currentPagingItem
        print(selectedVC)
        return true
    }
}

extension SearchResultVC: PagingViewControllerDataSource {
    
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
