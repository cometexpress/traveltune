//
//  SearchResultTabTravelSpotVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit

final class SearchResultTabTravelSpotVC: BaseViewController<SearchResultTabTravelSpotView> {
    
//    var keyword: String?
//    
//    convenience init(keyword: String?) {
//        self.init()
//        self.keyword = keyword
//    }
    
    var viewModel: SearchResultTabTravelSpotViewModel?
    
    convenience init(viewModel: SearchResultTabTravelSpotViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureVC() {
        guard let viewModel else { return }
        mainView.viewModel = viewModel
        mainView.searchResultTabTravelSpotVCProtocol = self
        viewModel.searchSpots(page: mainView.page)
        bindData()
    }
    
    private func bindData() {
        viewModel?.state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initValue: Void()
            case .loading:
                LoadingIndicator.show()
                if self.mainView.page == 1 {
                    self.mainView.spotItems.removeAll()
                    self.mainView.applySnapShot(items: self.mainView.spotItems)
                }
            case .success(let data):
                if self.mainView.page == 1 {
                    self.mainView.spotItems.removeAll()
                }
                self.mainView.spotItems.append(contentsOf: data)
                self.mainView.applySnapShot(items: self.mainView.spotItems)
                
                self.mainView.containerView.isHidden = self.mainView.spotItems.isEmpty
                self.mainView.emptyLabel.isHidden = !self.mainView.spotItems.isEmpty
                
                LoadingIndicator.hide()
            case .error(let msg):
                print(msg)
                LoadingIndicator.hide()
                if self.mainView.page == 1 {
                    self.mainView.containerView.isHidden = self.mainView.spotItems.isEmpty
                    self.mainView.emptyLabel.isHidden = !self.mainView.spotItems.isEmpty
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("관광지 ON")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("관광지 OFF")
    }
}

extension SearchResultTabTravelSpotVC: SearchResultTabTravelSpotVCProtocol {
    
    func willDisplay(page: Int) {
        viewModel?.searchSpots(page: page)
    }
}
