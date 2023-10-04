//
//  SearchVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit
import SnapKit

final class SearchVC: BaseViewController<SearchView> {
    
    private let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        viewModel.fetchWords()
    }
    
    override func configureVC() {
        mainView.viewModel = viewModel
        mainView.searchVCProtocol = self
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        navigationItem.titleView = mainView.naviBarSearchTextField
        
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.naviBarSearchTextField.resignFirstResponder()
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    private func bindData() {
        viewModel.words.bind { [weak self] words in
            self?.mainView.configureSnapShot(recommendItems: words.recommendWords, recentItems: words.recentSearchKeywords)
        }
        
        viewModel.isExistSearchText.bind { [weak self] status in
            switch status {
            case .initial:
                print("init")
            case .empty:
                self?.showToast(msg: Strings.Common.searchPlaceHolder, position: .center)
            case .exist(let searchText):                
                self?.moveSearchResult(searchText: searchText)
            }
        }
    }
    
    private func moveSearchResult(searchText: String) {
        let vc = SearchResultVC()
        vc.searchKeyword = searchText
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchVC: SearchVCProtocol {
    func textfieldDoneClicked(searchText: String) {
        viewModel.checkSearchText(searchText: searchText)
    }
    
    func recommendWordClicked(searchText: String) {
        moveSearchResult(searchText: searchText)
    }
    
    func recentWordClicked(searchText: String) {
        moveSearchResult(searchText: searchText)
    }
    
    func deleteRecentWordClicked(item: SearchController.RecentSearchItem) {
        viewModel.deleteSearchKeyword(id: item.id)
    }
}

extension SearchVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

