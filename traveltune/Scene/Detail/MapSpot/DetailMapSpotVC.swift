//
//  DetailMapSpotVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/11.
//

import UIKit

final class DetailMapSpotVC: BaseViewController<DetailMapSpotView, DetailMapSpotViewModel> {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }
    
    func configureVC() {
        mainView.viewModel = viewModel
        mainView.detailMapSpotVCProtocol = self
    }
    
    func bindViewModel() {
        
    }
}

extension DetailMapSpotVC: DetailMapSpotVCProtocol {
    
    func backClicked() {
        dismiss(animated: false)
    }
}
