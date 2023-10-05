//
//  SearchResultTabStoryVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit

final class SearchResultTabStoryVC: BaseViewController<SearchResultTabStoryView> {
    
    var viewModel: SearchResultTabStoryViewModel?
    
    convenience init(viewModel: SearchResultTabStoryViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureVC() {
        print("이야기 = ", viewModel?.keyword)
    }
}
