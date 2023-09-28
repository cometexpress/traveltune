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
    
    override func configureVC() {
        mainView.themeDetailVCProtocol = self
        guard let themeStory else { return }
        print("현재 컨텐츠 정보 \(themeStory.title)")
        mainView.hero.modifiers = [.translate(y:100)]
        mainView.backgroundImageView.image = themeStory.thumbnail
        mainView.topTitleLabel.text = themeStory.title
    }
    
}

extension ThemeDetailVC: ThemeDetailVCProtocol {
    func backButtonClicked() {
        mainView.topView.isHidden = true
        dismiss(animated: true)
    }
    
    func infoButtonClicked() {
        print("상세 내용 보는 기능")
    }
    
    
}
