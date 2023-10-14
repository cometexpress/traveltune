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
        mainView.detailMapSpotVCProtocol = self
        mainView.viewModel = viewModel
    }
    
    func bindViewModel() {
        viewModel?.favoriteStoryObserve()
        viewModel?.state.bind { state in
            switch state {
            case .initValue: Void()
            case .likeUpdateSuccess:
                self.mainView.collectionView.reloadData()
            case .error(let msg):
                print(msg)
            }
        }
    }
}

extension DetailMapSpotVC: DetailMapSpotVCProtocol {

    func backClicked() {
        dismiss(animated: false)
    }
    
    func moveMapClicked() {
        // 현재 보여지고 있는 이야기 목록리스트 지도에 보여주기
        print("추후 업데이트")
    }
    
    func didSelectItemAt(item: StoryItem) {
        let vc = DetailStoryVC(viewModel: DetailStoryViewModel(storyRepository: StoryRepository(), localFavoriteStoryRepository: LocalFavoriteStoryRepository()))
        vc.viewModel?.detailStory.value = item
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
    
    func cellHeartButtonClicked(item: StoryItem) {
        guard let url = URL(string: item.audioURL) else {
            showAlert(title: "", msg: Strings.ErrorMsg.errorNoFile, ok: Strings.Common.ok)
            return
        }
        if item.isFavorite {
            viewModel?.deleteFavoriteStory(item: item)
        } else {
            viewModel?.addFavoriteStory(item: item)
        }
    }
}
