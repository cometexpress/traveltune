//
//  SearchResultVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/03.
//

import UIKit

final class SearchResultVC: BaseViewController<SearchResultView> {
    
    var searchKeyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("검색어 = ", searchKeyword)
    }
    
    override func configureVC() {
        
    }
}
