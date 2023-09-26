//
//  HomeViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import Foundation

final class HomeViewModel {
    
    var themes: Observable<[ThemeStory]> = Observable([])
    
    func updateThemes() {
        themes.value = ThemeStory.allCases
    }
}
