//
//  SearchResultTabVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/03.
//

import UIKit

final class SearchResultTabVC: BaseViewController<SearchResultTabView> {
    
    var searchKeyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.naviBarSearchTextField.resignFirstResponder()
    }
    
    override func configureVC() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        mainView.naviBarSearchTextField.text = searchKeyword ?? ""
        navigationItem.titleView = mainView.naviBarSearchTextField
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}
