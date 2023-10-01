//
//  ThemeDetailVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit
import Hero
import CoreMedia

final class ThemeDetailVC: BaseViewController<ThemeDetailView> {
    
    var themeStory: ThemeStory?
    private let viewModel = ThemeDetailViewModel()
    
    override func configureVC() {
        mainView.themeDetailVCProtocol = self
        mainView.viewModel = viewModel
        
        guard let themeStory else { return }
        mainView.hero.modifiers = [.translate(y:100)]
        mainView.backgroundImageView.image = themeStory.thumbnail
        mainView.topTitleLabel.text = themeStory.title
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.mainView.collectionView.isHidden = false
        }
        
        bindData()
        
        // 재생완료시점 확인용
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playingMusicFinish(_:)),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        
        //        let testURL = URL(string: "https://sfj608538-sfj608538.ktcdn.co.kr/file/audio/56/7237.mp3")!
        
    }
    
    private func bindData() {
        guard let themeStory else { return }
        viewModel.fetchThemeStoriesData(keyword: themeStory.searchKeyword)
        viewModel.stories.bind { items in
            self.mainView.collectionView.reloadData()
        }
    }
    
    //현재 진행중인 PlayerItem이 EndTime에 도달하면 호출
    @objc func playingMusicFinish(_ notification: Notification) {
        //필요한 정보나 객체가 있으면 object를 통해서 받아서 이용
        print("재생이 완료되었어요")
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
        let url = viewModel.stories.value.first?.audioURL
        guard let url, let testURL = URL(string: url) else { return }
        AVPlayerManager.shared.play(url: testURL)
    }
    
    func sliderValueChanged(value: Float) {
        guard let duration = AVPlayerManager.shared.player.currentItem?.duration else { return }
        let value = Float64(value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        AVPlayerManager.shared.player.seek(to: seekTime)
    }
    
    func cellHeartButtonClicked(item: StoryItem) {
        if item.isFavorite {
            viewModel.deleteFavoriteStory(item: item)
        } else {
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

