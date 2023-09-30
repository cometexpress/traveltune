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
        
        viewModel.fetchStories(searchKeyword: themeStory.searchKeyword)
        viewModel.stories.bind { items in
            print("몇개인가 = ", items.count)
            self.mainView.collectionView.reloadData()
        }
    }
    
    private func bindData() {
        
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
    
}

