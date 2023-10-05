//
//  SearchResultTabTravelSpotVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit

final class SearchResultTabTravelSpotVC: BaseViewController<SearchResultTabTravelSpotView> {
    
    var viewModel: SearchResultTabTravelSpotViewModel?
    
    convenience init(viewModel: SearchResultTabTravelSpotViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("관광지 = ", viewModel?.searchKeyword)
    }
    
    override func configureVC() {
        
    }
}
