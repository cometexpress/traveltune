//
//  SearchResultVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit
import Parchment
import SnapKit

final class SearchResultVC: BaseViewController<SearchResultView> {
    
    var searchKeyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureVC() {
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        mainView.naviBarSearchTextField.text = searchKeyword
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        navigationItem.titleView = mainView.naviBarSearchTextField
        
        addChild(mainView.commonTabPaingVC)
        mainView.commonTabPaingVC.didMove(toParent: self)
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}


