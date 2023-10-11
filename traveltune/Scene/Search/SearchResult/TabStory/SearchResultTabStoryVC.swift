//
//  SearchResultTabStoryVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/04.
//

import UIKit

final class SearchResultTabStoryVC: BaseViewController<SearchResultTabStoryView, SearchResultTabStoryViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 오류 발생
        // 페이징 - 상세페이지 - 뒤로가기 하면 identifier 오류 발생
//        bindViewModel()
    }
    
    func configureVC() {
        mainView.viewModel = viewModel
        mainView.searchResultTabStoryVCProtocol = self
        bindViewModel()
        viewModel?.searchStories(page: mainView.page)
    }
    
    func bindViewModel() {
        viewModel?.state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initValue: Void()
            case .loading:
                mainView.showLoading()
                if self.mainView.page == 1 {
                    self.mainView.storyItems.removeAll()
                    self.mainView.applySnapShot(items: self.mainView.storyItems)
                }
            case .success(let data):
                if self.mainView.page == 1 {
                    self.mainView.storyItems.removeAll()
                }
                self.mainView.storyItems.append(contentsOf: data)
                self.mainView.applySnapShot(items: self.mainView.storyItems)
                
                self.mainView.containerView.isHidden = self.mainView.storyItems.isEmpty
                self.mainView.emptyLabel.isHidden = !self.mainView.storyItems.isEmpty

                mainView.hideLoading()
            case .error(let msg):
                print(msg)
                mainView.hideLoading()
                if self.mainView.page == 1 {
                    self.mainView.containerView.isHidden = self.mainView.storyItems.isEmpty
                    self.mainView.emptyLabel.isHidden = !self.mainView.storyItems.isEmpty
                }
            }
        }
    }
}

extension SearchResultTabStoryVC: SearchResultTabStoryVCProtocol {
    
    func didSelectItemAt(item: StoryItem) {
        // 상세로 이동시키기
        let vc = DetailStoryVC(
            viewModel: DetailStoryViewModel(
                storyRepository: StoryRepository(),
                localFavoriteStoryRepository: LocalFavoriteStoryRepository()
            )
        )
        vc.viewModel?.detailStory.value = item
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    func willDisplay(page: Int) {
        viewModel?.searchStories(page: page)
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
