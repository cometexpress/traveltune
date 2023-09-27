//
//  ThemeDetailVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit

final class ThemeDetailVC: BaseViewController<ThemeDetailView> {
    
    var themeStory: ThemeStory?
    
    override func configureVC() {
        print(themeStory?.searchKeyword)
    }
    
}
