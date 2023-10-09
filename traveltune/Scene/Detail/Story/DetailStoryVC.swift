//
//  DetailStoryVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/09.
//

import Foundation

final class DetailStoryVC: BaseViewController<DetailStoryView, DetailStoryViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
    }
    
    func bindViewModel() {
        viewModel?.detailStory.bind { [weak self] item in
            guard let item else { return }
            print(item)
            self?.mainView.fetchData(item: item)
        }
    }
    
    func configureVC() {
        mainView.detailStoryProtocol = self
    }
    
}

extension DetailStoryVC: DetailStoryProtocol {
    
    func backButtonClicked() {
        dismiss(animated: true)
    }
    
}
