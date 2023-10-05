//
//  SearchResultTabTravelSpotVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit

final class SearchResultTabTravelSpotVC: BaseViewController<SearchResultTabTravelSpotView> {
    
    var keyword: String?
    
    var page = 1
    
    convenience init(keyword: String?) {
        self.init()
        self.keyword = keyword
    }
    
    let viewModel = SearchResultTabTravelSpotViewModel(travelSportRepository: TravelSpotRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureVC() {
        guard let keyword else { return }
        viewModel.searchSpots(searchKeyword: keyword, page: page)
        bindData()
    }
    
    private func bindData() {
        viewModel.state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initValue: Void()
            case .loading:
                LoadingIndicator.show()
            case .success(let data):
                if self.page == 1 {
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
