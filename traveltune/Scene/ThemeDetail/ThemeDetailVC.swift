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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.stop()
    }
    
    override func configureVC() {
        mainView.themeDetailVCProtocol = self
        mainView.playerBottomView.playerBottomProtocol = self
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
        AVPlayerManager.shared.stop()
        mainView.playerBottomView.resetData()
        viewModel.stories.value = viewModel.stories.value.map { 
            $0.isPlaying = false
            return $0
        }
    }
}

extension ThemeDetailVC: PlayerBottomProtocol {
    func previousClicked() {
        print("이전 이야기")
    }
    
    func nextClicked() {
        print("다음 이야기")
    }
    
    func playAndPauseClicked() {
        switch AVPlayerManager.shared.status {
        case .playing:  // 재생중일 때 누르면 할 일
            AVPlayerManager.shared.pause()
            mainView.playerBottomView.addPlayAndPauseImage(isPlaying: true)
        case .stop:     // 멈춰있을 때 누르면 할 일
            AVPlayerManager.shared.replay()
            mainView.playerBottomView.addPlayAndPauseImage(isPlaying: false)
        case .waitingToPlay:
            print("로딩 중")
        }
    }
    
    func thumbImageClicked() {
        print("이미지 클릭")
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
    
    func cellHeartButtonClicked(item: StoryItem) {
        if item.isFavorite {
            viewModel.deleteFavoriteStory(item: item)
        } else {
            viewModel.addFavoriteStory(item: item)
        }
    }
    
    func didSelectItemAt(item: StoryItem) {
        viewModel.stories.value = viewModel.stories.value.map {
            $0.isPlaying = false
            if $0 == item {
                $0.isPlaying = !item.isPlaying
            }
            return $0
        }
        
        guard let playItem = viewModel.stories.value.filter({ $0.isPlaying == true }).first,
            let audioURL = URL(string: playItem.audioURL) else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.play(url: audioURL)
        AVPlayerManager.shared.addPlayTimeObserver { interval, playTime in
            let seconds = String(format: "%02d", Int(playTime) % 60)
            let minutes = String(format: "%02d", Int(playTime / 60))
            print("interval = \(interval)")
            print("\(minutes):\(seconds)")
            self.mainView.playerBottomView.audioSlider.value = interval
        }
        self.mainView.playerBottomView.updateData(
            title: playItem.audioTitle.isEmpty ? playItem.title : playItem.audioTitle,
            thumbnail: playItem.imageURL
        )
    }
}

