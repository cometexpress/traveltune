//
//  FavoriteAudioGuideViewModel.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/16.
//

import Foundation

final class FavoriteAudioGuideViewModel: BaseViewModel {
    
    private var localFavoriteStoryRepository: LocalFavoriteStoryRepository
    
    init(localFavoriteStoryRepository: LocalFavoriteStoryRepository) {
        self.localFavoriteStoryRepository = localFavoriteStoryRepository
    }
    
}
