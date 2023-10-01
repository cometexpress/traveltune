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
        LoadingIndicator.show()
        mainView.themeDetailVCProtocol = self
        mainView.playerBottomView.playerBottomProtocol = self
        mainView.viewModel = viewModel
        
        guard let themeStory else { return }
        mainView.hero.modifiers = [.translate(y:100)]
        mainView.backgroundImageView.image = themeStory.thumbnail
        mainView.topTitleLabel.text = themeStory.title
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.mainView.collectionView.isHidden = false
            self.mainView.playerBottomView.isHidden = false
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
    
//    private func configureSnapshot(items: [StoryItem]) {
//        var snapshot = NSDiffableDataSourceSnapshot<Int, StoryItem>()
//        snapshot.appendSections([0])
//        snapshot.appendItems(items)
//        self.mainView.dataSource.apply(snapshot, animatingDifferences: true)
//    }
    
    private func bindData() {
        guard let themeStory else { return }
        viewModel.fetchThemeStoriesData(keyword: themeStory.searchKeyword)
        viewModel.stories.bind { items in
            self.mainView.configureSnapshot(items: items)
//            self.configureSnapshot(items: items)
//            self.mainView.collectionView.reloadData()
            LoadingIndicator.hide()
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
    
    private func audioPlay(url: URL) {
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.play(url: url)
        AVPlayerManager.shared.addPlayTimeObserver { interval, playTime in
            let seconds = String(format: "%02d", Int(playTime) % 60)
            let minutes = String(format: "%02d", Int(playTime / 60))
//            print("interval = \(interval)")
//            print("\(minutes):\(seconds)")
            self.mainView.playerBottomView.audioSlider.value = interval
        }
    }
}

extension ThemeDetailVC: PlayerBottomProtocol {
    
    func previousClicked() {
        guard let playItem = viewModel.stories.value.filter({ $0.isPlaying == true }).first else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        
        guard let currentIndex = viewModel.stories.value.firstIndex(of: playItem) else {
            return
        }
        
        if currentIndex == 0 {
            showToast(msg: Strings.Common.errorFirstStory)
        } else {
            let previousItemIndex = currentIndex - 1
            let previousPlayItem = viewModel.stories.value[previousItemIndex]
            
            if let audioURL = URL(string: previousPlayItem.audioURL) {
                audioPlay(url: audioURL)
                self.mainView.playerBottomView.updateData(
                    title: previousPlayItem.audioTitle.isEmpty ? previousPlayItem.title : previousPlayItem.audioTitle,
                    thumbnail: previousPlayItem.imageURL
                )
                
                viewModel.stories.value = viewModel.stories.value.map {
                    $0.isPlaying = false
                    if $0 == previousPlayItem {
                        $0.isPlaying = !previousPlayItem.isPlaying
                    }
                    return $0
                }
            }
        }
    }
    
    func nextClicked() {
        guard let playItem = viewModel.stories.value.filter({ $0.isPlaying == true }).first else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        
        guard let currentIndex = viewModel.stories.value.firstIndex(of: playItem) else {
            return
        }
        
        if currentIndex == viewModel.stories.value.count - 1 {
            showToast(msg: Strings.Common.errorLastStory)
        } else {
            let nextItemIndex = currentIndex + 1
            let nextPlayItem = viewModel.stories.value[nextItemIndex]
            
            if let audioURL = URL(string: nextPlayItem.audioURL) {
                audioPlay(url: audioURL)
                self.mainView.playerBottomView.updateData(
                    title: nextPlayItem.audioTitle.isEmpty ? nextPlayItem.title : nextPlayItem.audioTitle,
                    thumbnail: nextPlayItem.imageURL
                )
                
                viewModel.stories.value = viewModel.stories.value.map {
                    $0.isPlaying = false
                    if $0 == nextPlayItem {
                        $0.isPlaying = !nextPlayItem.isPlaying
                    }
                    return $0
                }
            }
        }
    }
    
    func playAndPauseClicked() {
        // StoryItem 안의 isPlaying 값은 재생시작 때 관리
        // 일시정지할 때는 viewModel.stories.value 의 StoryItem 안의 isPlaying 값 그대로 true 로 유지
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
        mainView.playerBottomView.isHidden = true
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
        
        audioPlay(url: audioURL)
        self.mainView.playerBottomView.updateData(
            title: playItem.audioTitle.isEmpty ? playItem.title : playItem.audioTitle,
            thumbnail: playItem.imageURL
        )
    }
}

