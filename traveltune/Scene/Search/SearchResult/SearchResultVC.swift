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
    
    private var tabTravelSpotViewModel = SearchResultTabTravelSpotViewModel()
    private var tabStoryViewModel = SearchResultTabStoryViewModel()
    
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
        tabTravelSpotViewModel = SearchResultTabTravelSpotViewModel(
            keyword: searchKeyword,
            travelSportRepository: TravelSpotRepository()
        )
        
        tabStoryViewModel = SearchResultTabStoryViewModel(
            keyword: searchKeyword,
            storyRepository: StoryRepository()
        )
        
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
        
        switch commonTabPaingVC.state {
        case .empty: Void()
        case .selected(let pagingItem):
            print(pagingItem.identifier)
        case .scrolling: Void()
        }
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchResultVC: UITextFieldDelegate {
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 검색버튼 눌렀을 때 관광지 와 이야기 탭 모두 업데이트 해줘야 하지 않을까?
        // TODO: 검색버튼 눌렀을 때 관광지 이야기 탭 모두 업데이트 시키기
        
        // TODO: 현재 선택되어진 아이템만 업데이트 시키고 있는 코드 모두 업데이트 시키도록 수정필요
        if let selectedPagingItem = commonTabPaingVC.state.currentPagingItem {
            if selectedPagingItem.isEqual(to: PagingIndexItem(index: 0, title: Strings.SearchTabTitle.TravelSpot)) {
                print("관광지 뷰모델 데이터 업데이트")
                let travelSpotVC = commonTabPaingVC.tabViewControllers[0] as? SearchResultTabTravelSpotVC
                travelSpotVC?.mainView.page = 1
                travelSpotVC?.viewModel?.searchSpots(page: 1)
            } else {
                print("이야기 뷰모델 데이터 업데이트")
                let storyVC = commonTabPaingVC.tabViewControllers[1] as? SearchResultTabStoryVC
                
            }
        }
        return true
    }
}

extension SearchResultVC: PagingViewControllerDataSource, PagingViewControllerDelegate {
    
    func pagingViewController(_ pagingViewController: PagingViewController, didSelectItem pagingItem: PagingItem) {
        print(pagingItem)
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
