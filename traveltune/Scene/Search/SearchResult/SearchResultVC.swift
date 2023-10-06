//
//  SearchResultVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit
import Parchment
import SnapKit

final class SearchResultVC: UIViewController {
    
    var searchKeyword: String?
    
    private var viewModel = SearchResultViewModel()
    
    private lazy var tabTravelSpotViewModel = SearchResultTabTravelSpotViewModel(
        keyword: searchKeyword,
        travelSportRepository: TravelSpotRepository()
    )
    
    private lazy var tabStoryViewModel = SearchResultTabStoryViewModel(
        keyword: searchKeyword,
        storyRepository: StoryRepository()
    )
    
    private var commonTabPaingVC = CommonTabPagingVC()
    
    private lazy var naviBarSearchTextField = SearchTextField().setup { view in
        let width = UIScreen.main.bounds.width - 80
        view.frame = .init(x: 0, y: 0, width: width, height: 40)
        view.delegate = self
        view.addTarget(self, action: #selector(self.naviBarSearchTextFieldChanged(_:)), for: .editingChanged)
    }
    
    @objc func naviBarSearchTextFieldChanged(_ sender: UITextField) {
        // 하위 뷰컨트롤러 뷰모델 searchKeyword 값에 전달해주기
        guard let text = sender.text else { return }
        tabTravelSpotViewModel.keyword = text
        tabStoryViewModel.keyword = text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        // 최초 검색키워드 전달을 위해 이때 초기화
        commonTabPaingVC = CommonTabPagingVC(
            viewControllers: [
                SearchResultTabTravelSpotVC(viewModel: tabTravelSpotViewModel),
                SearchResultTabStoryVC(viewModel: tabStoryViewModel)
            ],
            tabTitles: [Strings.SearchTabTitle.TravelSpot, Strings.SearchTabTitle.Story]
        )
        
        configureHierarchy()
        configureLayout()
        configureVC()
        
        // ChildVC 의 컬렉션뷰 스크롤 감지
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(beginScrollObserver),
            name: .beginScroll,
            object: nil
        )
    }
    
    @objc func beginScrollObserver(notification: NSNotification) {
        // 노티피케이션센터로 데이터 전달 받을 때
        //           if let title = notification.userInfo?["title"] as? String {
        //               print(title)
        //           }
        naviBarSearchTextField.resignFirstResponder()
        
    }
    
    private func configureHierarchy() {
        commonTabPaingVC.dataSource = self
        commonTabPaingVC.delegate = self
        //        commonTabPaingVC.sizeDelegate = self
        view.addSubview(commonTabPaingVC.view)
    }
    
    private func configureLayout() {
        commonTabPaingVC.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func configureVC() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        naviBarSearchTextField.text = searchKeyword
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        navigationItem.titleView = naviBarSearchTextField
        
        addChild(commonTabPaingVC)
        commonTabPaingVC.didMove(toParent: self)
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchResultVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // TODO: 검색버튼 눌렀을 때 최근검색 Realm 에 저장하기
        let travelSpotVC = commonTabPaingVC.tabViewControllers[0] as? SearchResultTabTravelSpotVC
        travelSpotVC?.mainView.page = 1
        travelSpotVC?.viewModel?.searchSpots(page: 1)
        
        let storyVC = commonTabPaingVC.tabViewControllers[1] as? SearchResultTabStoryVC
        storyVC?.mainView.page = 1
        storyVC?.viewModel?.searchStories(page: 1)
        
        // 선택한 탭이 어떤건지 확인할 떄
        //        if let selectedPagingItem = commonTabPaingVC.state.currentPagingItem {
        //            if selectedPagingItem.isEqual(to: PagingIndexItem(index: 0, title: Strings.SearchTabTitle.TravelSpot)) {
        //                print("관광지 탭")
        //            } else {
        //                print("이야기 탭")
        //            }
        //        }
        return true
    }
}

extension SearchResultVC: PagingViewControllerDataSource, PagingViewControllerDelegate {
    
    func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem pagingItem: PagingItem) {
        //        print(pagingItem)
    }
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return commonTabPaingVC.tabTitles.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return commonTabPaingVC.tabViewControllers[index]
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: commonTabPaingVC.tabTitles[index])
    }
    
}
