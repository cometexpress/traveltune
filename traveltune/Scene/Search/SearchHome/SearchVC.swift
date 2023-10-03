//
//  SearchVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/02.
//

import UIKit
import SnapKit

final class SearchVC: BaseViewController<SearchView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.searchVCProtocol = self
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.naviBarSearchTextField.resignFirstResponder()
    }
    
    override func configureVC() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        navigationItem.titleView = mainView.naviBarSearchTextField
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    private func checkSearchText(searchText: String) -> Bool {
        return searchText.isEmpty ? false : true
    }
    
    private func moveSearchResult(searchText: String) {
        let vc = SearchResultVC()
        vc.searchKeyword = searchText
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchVC: SearchVCProtocol {
    func textfieldDoneClicked(searchText: String) {
        if checkSearchText(searchText: searchText) {
            moveSearchResult(searchText: searchText)
        } else {
            showToast(msg: Strings.Common.searchPlaceHolder, position: .center)
        }
    }
    
    func recommendWordClicked(searchText: String) {
        moveSearchResult(searchText: searchText)
    }
    
    func recentWordClicked(searchText: String) {
        moveSearchResult(searchText: searchText)
    }
    
    func deleteRecentWordClicked() {
        print(#function)
    }
}

extension SearchVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

