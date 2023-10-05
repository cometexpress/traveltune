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
    
    private let viewModel = ThemeDetailViewModel(
        localTravelSpotRepository: LocalTravelSpotRepository(),
        localThemeStoryRepository: LocalThemeStoryRepository(),
        localFavoriteStoryRepository: LocalFavoriteStoryRepository(),
        storyRepository: StoryRepository()
    )
    
    private var themeStoryItems: [StoryItem] = []
    
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
    
    private func bindData() {
        guard let themeStory else { return }
        viewModel.fetchThemeStoriesData(keyword: themeStory.searchKeyword)
        
        viewModel.state.bind { [weak self] state in
            switch state {
            case .initValue: Void()
            case .loading: LoadingIndicator.show()
            case .success(let data):
                self?.themeStoryItems.append(contentsOf: data)
                self?.mainView.applySnapshot(items: data)
                LoadingIndicator.hide()
            case .singleDataError:
                LoadingIndicator.hide()
                // 데이터중 몇개씩 오류 발생할 때 어떻게 할지?
//                self?.showToast(msg: Strings.ErrorMsg.errorLoadingData)
            case .localDataLoadError:
                LoadingIndicator.hide()
                self?.showToast(msg: Strings.ErrorMsg.errorLoadingData)
            case .error(let msg):
                print("error : ", msg)
                LoadingIndicator.hide()
                self?.showToast(msg: Strings.ErrorMsg.errorLoadingData)
            }
        }
        
    }
    
    //현재 진행중인 PlayerItem이 EndTime에 도달하면 호출
    @objc func playingMusicFinish(_ notification: Notification) {
        //필요한 정보나 객체가 있으면 object를 통해서 받아서 이용
        print("재생이 완료되었어요")
        AVPlayerManager.shared.stop()
        mainView.playerBottomView.resetData()
        themeStoryItems = themeStoryItems.map {
            $0.isPlaying = false
            return $0
        }
        mainView.applySnapshot(items: themeStoryItems)
    }
    
    private func audioPlay(url: URL) {
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.play(url: url)
        AVPlayerManager.shared.addPlayTimeObserver { interval, playTime in
//            let seconds = String(format: "%02d", Int(playTime) % 60)
//            let minutes = String(format: "%02d", Int(playTime / 60))
//            print("interval = \(interval)")
//            print("\(minutes):\(seconds)")
            self.mainView.playerBottomView.audioSlider.value = interval
        }
    }
    
    private func currentPlayingItemIndex() -> Int? {
        guard let playItem = themeStoryItems.filter({ $0.isPlaying == true }).first,
              let index = themeStoryItems.firstIndex(of: playItem) else {
            return nil
        }
        return index
    }
    
    private func updateData(item: StoryItem) {
        self.mainView.playerBottomView.updateData(
            title: item.audioTitle.isEmpty ? item.title : item.audioTitle,
            thumbnail: item.imageURL
        )
        self.mainView.scriptView.updateData(
            title: item.audioTitle.isEmpty ? item.title : item.audioTitle,
            script: item.script
        )
    }
}

extension ThemeDetailVC: PlayerBottomProtocol {
    
    func previousClicked() {
        guard let currentIndex = currentPlayingItemIndex() else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        
        if currentIndex == 0 {
            showToast(msg: Strings.Common.errorFirstStory)
        } else {
            let previousItemIndex = currentIndex - 1
            let previousPlayItem = themeStoryItems[previousItemIndex]
            
            if let audioURL = URL(string: previousPlayItem.audioURL) {
                audioPlay(url: audioURL)
                updateData(item: previousPlayItem)
                themeStoryItems = themeStoryItems.map {
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
        guard let currentIndex = currentPlayingItemIndex() else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        
        if currentIndex == themeStoryItems.count - 1 {
            showToast(msg: Strings.Common.errorLastStory)
        } else {
            let nextItemIndex = currentIndex + 1
            let nextPlayItem = themeStoryItems[nextItemIndex]
            
            if let audioURL = URL(string: nextPlayItem.audioURL) {
                audioPlay(url: audioURL)
                updateData(item: nextPlayItem)
                themeStoryItems = themeStoryItems.map {
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
        // 재생중인 아이템이 없을 때는 실행 안되도록
        guard let playItem = themeStoryItems.filter({ $0.isPlaying == true }).first else {
            return
        }
        
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
        if mainView.scriptView.isHidden {
            mainView.showScriptView()
        } else {
            mainView.hideScriptView()
        }        
    }
    
}

extension ThemeDetailVC: ThemeDetailVCProtocol {
    
    func backButtonClicked() {
        mainView.topView.isHidden = true
        mainView.collectionView.isHidden = true
        mainView.playerBottomView.isHidden = true
        mainView.scriptView.isHidden = true
        dismiss(animated: true)
    }
    
    func infoButtonClicked() {
        let vc = ThemeDetailInfoVC()
        vc.themeStory = themeStory
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func cellHeartButtonClicked(item: StoryItem) {
        if item.isFavorite {
            viewModel.deleteFavoriteStory(item: item)
        } else {
            viewModel.addFavoriteStory(item: item)
        }
    }
    
    func didSelectItemAt(item: StoryItem) {
        themeStoryItems = themeStoryItems.map {
            $0.isPlaying = false
            if $0 == item {
                $0.isPlaying = !item.isPlaying
            }
            return $0
        }
        
        guard let playItem = themeStoryItems.filter({ $0.isPlaying == true }).first,
              let audioURL = URL(string: playItem.audioURL) else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        self.mainView.applySnapshot(items: themeStoryItems)
        audioPlay(url: audioURL)
        updateData(item: playItem)
    }
}

