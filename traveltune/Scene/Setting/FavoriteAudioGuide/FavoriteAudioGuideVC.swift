//
//  FavoriteAudioGuideVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/16.
//

import UIKit

final class FavoriteAudioGuideVC: BaseViewController<FavoriteAudioGuideView, FavoriteAudioGuideViewModel> {
    
    var naviTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = naviTitle
    }
    
    func bindViewModel() {
        viewModel?.favoriteStoryObserve()
        viewModel?.state.bind { [weak self] state in
            switch state {
            case .initValue: Void()
            case .success(let data):
                if data.isEmpty {
                    self?.mainView.showEmptyLabel()
                } else {
                    self?.mainView.favoriteStories = data
                    self?.mainView.updateCountLabel(count: data.count)
                }
                
            case .deleteUpdate(let data):
                if data.isEmpty {
                    self?.mainView.showEmptyLabel()
                } else {
                    self?.mainView.favoriteStories = data
                    self?.mainView.updateCountLabel(count: data.count)
                }
            case .error(let msg):
                print(msg)
                self?.showToast(msg: Strings.ErrorMsg.errorLoadingData)
            }
        }
    }
    
    func configureVC() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.background
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.txtPrimary,
            .font: UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)
        ]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.backButtonDisplayMode = .minimal
        
        mainView.favoriteAudioGuideProtocol = self
    }
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

extension FavoriteAudioGuideVC: FavoriteAudioGuideVCProtocol {
    
    func cellHeartButtonClicked(item: FavoriteStory) {
        showAlert(
            title: "",
            msg: Strings.Common.alertMsgDeleteStoryItem,
            ok: Strings.Common.ok,
            no: Strings.Common.cancel
        ) { [weak self] _ in
            self?.viewModel?.deleteFavoriteStory(item: item)
        }
    }
    
    func didSelectItemAt(item: FavoriteStory) {
        // 재생시키기
    }
 
}

extension FavoriteAudioGuideVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
