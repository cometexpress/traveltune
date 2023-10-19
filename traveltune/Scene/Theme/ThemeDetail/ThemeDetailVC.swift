//
//  ThemeDetailVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit
import Hero
import CoreMedia

final class ThemeDetailVC: BaseViewController<ThemeDetailView, ThemeDetailViewModel> {
    
    var themeStory: ThemeStory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        bindViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MPRemoteCommandCenterManager.shared.unregisterRemoteCenter()
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.stop()
    }
    
    func configureVC() {
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
        
        // 재생완료시점 확인용
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playingMusicFinish(_:)),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        
        // RemoteCommandCenter 의 재생버튼 확인용
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(remotePlayerStatusObserver),
            name: .playerStatus,
            object: nil
        )
    }
    
    func bindViewModel() {
        guard let themeStory else { return }
        viewModel?.fetchThemeStoriesData(keyword: themeStory.searchKeyword)
        
        viewModel?.state.bind { [weak self] state in
            switch state {
            case .initValue: Void()
            case .loading: LoadingIndicator.show()
            case .success(let data):
                self?.mainView.themeStoryItems = data
                //                self?.mainView.applySnapshot(items: data)
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
    
    @objc func remotePlayerStatusObserver(notification: NSNotification) {
        if let status = notification.userInfo?["status"] as? String {
            let remoteStatus = AVPlayerManager.RemotePlayerStatus(rawValue: status)
            switch remoteStatus {
            case .play:
                mainView.playerBottomView.addPlayAndPauseImage(isPlaying: false)
            case .stop:
                mainView.playerBottomView.addPlayAndPauseImage(isPlaying: true)
            case nil:
                print("error")
            }
        }
    }
    
    //현재 진행중인 PlayerItem이 EndTime에 도달하면 호출
    @objc func playingMusicFinish(_ notification: Notification) {
        //필요한 정보나 객체가 있으면 object를 통해서 받아서 이용
        print("재생이 완료되었어요")
        AVPlayerManager.shared.stop()
        mainView.playerBottomView.resetData()
        mainView.themeStoryItems = mainView.themeStoryItems.map {
            $0.isPlaying = false
            return $0
        }
        MPRemoteCommandCenterManager.shared.unregisterRemoteCenter()
        //        mainView.applySnapshot(items: themeStoryItems)
    }
    
    private func audioPlay(item: StoryItem) {
        guard let url = URL(string: item.audioURL) else { return }
        let audioItem = AudioItem(audioUrl: url, title: item.audioTitle, imagePath: item.imageURL)
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.play(item: audioItem)
        AVPlayerManager.shared.addPlayTimeObserver(item: audioItem) { duration, interval, playTime in
            self.mainView.playerBottomView.audioSlider.value = interval
        }
    }
    
    private func currentPlayingItemIndex() -> Int? {
        guard let playItem = mainView.themeStoryItems.filter({ $0.isPlaying == true }).first,
              let index = mainView.themeStoryItems.firstIndex(of: playItem) else {
            return nil
        }
        return index
    }
    
    private func updateData(item: StoryItem) {
        mainView.playerBottomView.thumbImageView.isHidden = false
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
            showToast(msg: Strings.ErrorMsg.errorFirstStory)
        } else {
            let previousItemIndex = currentIndex - 1
            let previousPlayItem = mainView.themeStoryItems[previousItemIndex]
            
            audioPlay(item: previousPlayItem)
            updateData(item: previousPlayItem)
            mainView.themeStoryItems = mainView.themeStoryItems.map {
                $0.isPlaying = false
                if $0 == previousPlayItem {
                    $0.isPlaying = !previousPlayItem.isPlaying
                }
                return $0
            }
            //                mainView.applySnapshot(items: themeStoryItems)
        }
    }
    
    func nextClicked() {
        guard let currentIndex = currentPlayingItemIndex() else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        
        if currentIndex == mainView.themeStoryItems.count - 1 {
            showToast(msg: Strings.ErrorMsg.errorLastStory)
        } else {
            let nextItemIndex = currentIndex + 1
            let nextPlayItem = mainView.themeStoryItems[nextItemIndex]
            audioPlay(item: nextPlayItem)
            updateData(item: nextPlayItem)
            mainView.themeStoryItems = mainView.themeStoryItems.map {
                $0.isPlaying = false
                if $0 == nextPlayItem {
                    $0.isPlaying = !nextPlayItem.isPlaying
                }
                return $0
            }
            //            mainView.applySnapshot(items: themeStoryItems)
        }
    }
    
    func playAndPauseClicked() {
        // 재생중인 아이템이 없을 때는 실행 안되도록
        let playItem = mainView.themeStoryItems.filter { $0.isPlaying == true }.first
        if playItem == nil {
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
        let vc = ThemeDetailInfoVC(viewModel: nil)
        vc.themeStory = themeStory
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func cellHeartButtonClicked(item: StoryItem) {
        if item.isFavorite {
            print("delete 실행")
            viewModel?.deleteFavoriteStory(item: item)
        } else {
            print("add 실행")
            viewModel?.addFavoriteStory(item: item)
        }
    }
    
    func didSelectItemAt(item: StoryItem) {
        mainView.themeStoryItems = mainView.themeStoryItems.map {
            $0.isPlaying = false
            if $0 == item {
                $0.isPlaying = !item.isPlaying
            }
            return $0
        }
        
        guard let playItem = mainView.themeStoryItems.filter({ $0.isPlaying == true }).first else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        //        self.mainView.applySnapshot(items: themeStoryItems)
        audioPlay(item: playItem)
        updateData(item: playItem)
    }
}

