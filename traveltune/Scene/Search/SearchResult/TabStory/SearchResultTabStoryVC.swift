//
//  SearchResultTabStoryVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit

final class SearchResultTabStoryVC: BaseViewController<SearchResultTabStoryView, SearchResultTabStoryViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }
    
    func configureVC() {
        print("이야기 = ", viewModel?.keyword)
    }
    
    func bindViewModel() {
        
    }
}
