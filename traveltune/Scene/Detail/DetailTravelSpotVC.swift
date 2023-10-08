//
//  DetailTravelSpotVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/08.
//

import UIKit

final class DetailTravelSpotVC: BaseViewController<DetailTravelSpotView, DetailTravelSpotViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
    }
    
    func bindViewModel() {
        viewModel?.detailTravelSpot.bind { [weak self] item in
            guard let item else { return }
            self?.mainView.fetchData(item: item)
            print(item)
        }
    }
    
    func configureVC() {
        
    }
        
}
