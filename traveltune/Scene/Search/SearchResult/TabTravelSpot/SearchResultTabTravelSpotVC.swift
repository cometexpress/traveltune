//
//  SearchResultTabTravelSpotVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit

final class SearchResultTabTravelSpotVC: BaseViewController<SearchResultTabTravelSpotView, SearchResultTabTravelSpotViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
    }
    
    func configureVC() {
        mainView.viewModel = viewModel
        mainView.searchResultTabTravelSpotVCProtocol = self
        bindViewModel()
        viewModel?.searchSpots(page: mainView.page)
    }
    
    func bindViewModel() {
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
}

extension SearchResultTabTravelSpotVC: SearchResultTabTravelSpotVCProtocol {
    
    func didSelectItemAt(item: TravelSpotItem) {
        // 상세로 이동시키기
        let vc = DetailTravelSpotVC(viewModel: DetailTravelSpotViewModel(travelSportRepository: TravelSpotRepository()))
        vc.viewModel?.detailTravelSpot.value = item
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func willDisplay(page: Int) {
        viewModel?.searchSpots(page: page)
    }
    
    func scrollBeginDragging() {
        NotificationCenter.default.post(
                name: .beginScroll,
                object: nil,
                userInfo: nil
            )
//    userInfo: ["title" : "SecondTitle"]
    }
}
