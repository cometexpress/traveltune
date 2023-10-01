//
//  ThemeDetailVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit
import Hero

final class ThemeDetailVC: BaseViewController<ThemeDetailView> {
    
    var themeStory: ThemeStory?
    private let viewModel = ThemeDetailViewModel()
    
    override func configureVC() {
        mainView.themeDetailVCProtocol = self
        mainView.viewModel = viewModel
        guard let themeStory else { return }
        print("현재 컨텐츠 정보 \(themeStory.title)")
        mainView.hero.modifiers = [.translate(y:100)]
        mainView.backgroundImageView.image = themeStory.thumbnail
        mainView.topTitleLabel.text = themeStory.title
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.mainView.collectionView.isHidden = false
        }
        
        bindData()
    }
    
    private func bindData() {
        guard let themeStory else { return }
        viewModel.fetchThemeStoriesData(keyword: themeStory.searchKeyword)
        viewModel.stories.bind { items in
            self.mainView.collectionView.reloadData()
        }
    }
    
}

extension ThemeDetailVC: ThemeDetailVCProtocol {
    
    func backButtonClicked() {
        mainView.topView.isHidden = true
        mainView.collectionView.isHidden = true
        dismiss(animated: true)
    }
    
    func infoButtonClicked() {
        print("상세 내용 보는 기능")
    }
    
    func previousButtonClicked() {
        print("이전으로 스킵")
    }
    
    func nextButtonClicked() {
        print("다음으로 스킵")
    }
    
    func playAndPauseButtonClicked() {
        print("재생 or 일시정지 클릭")
    }
    
    func cellHeartButtonClicked(item: StoryItem) {
        if item.isFavorite {
            print("하트 삭제")
            viewModel.deleteFavoriteStory(item: item)
        } else {
            print("하트 추가")
            viewModel.addFavoriteStory(item: item)
        }
    }
    
    func cellPlayButtonClicked() {
        print("셀 재생버튼")
    }
    
    func cellContentClicked() {
        // TODO: 스크립트 보여주기
        print("셀 레이블 영역 클릭")
    }
}

