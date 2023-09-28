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
        guard let themeStory else { return }
        mainView.hero.modifiers = [.translate(y:100)]
        mainView.backgroundImageView.image = themeStory.thumbnail
//        print(themeStory?.searchKeyword)
    }
    
}
