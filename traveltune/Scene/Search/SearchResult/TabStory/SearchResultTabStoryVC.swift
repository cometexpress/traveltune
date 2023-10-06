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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
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
                LoadingIndicator.show()
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

                LoadingIndicator.hide()
            case .error(let msg):
                print(msg)
                LoadingIndicator.hide()
                if self.mainView.page == 1 {
                    self.mainView.containerView.isHidden = self.mainView.storyItems.isEmpty
                    self.mainView.emptyLabel.isHidden = !self.mainView.storyItems.isEmpty
                }
            }
        }
    }
}

extension SearchResultTabStoryVC: SearchResultTabStoryVCProtocol {
    
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
