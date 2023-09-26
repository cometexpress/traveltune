//
//  HomeViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/26.
//

import Foundation

final class ThemeViewModel {
    
    var themes: Observable<[ThemeStory]> = Observable([])
    
    func updateThemes() {
        themes.value = ThemeStory.allCases
    }
}
