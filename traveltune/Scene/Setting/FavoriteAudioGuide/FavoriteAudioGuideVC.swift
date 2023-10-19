//
//  FavoriteAudioGuideVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/16.
//

import UIKit

final class FavoriteAudioGuideVC: BaseViewController<FavoriteAudioGuideView, FavoriteAudioGuideViewModel> {
    
    var naviTitle: String?
    
    private var currentPlayingAudioURL = ""
    
    private var isContinuousPlay = false // 연속 재생 여부
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = naviTitle
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MPRemoteCommandCenterManager.shared.unregisterRemoteCenter()
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.stop()
    }
    
    func bindViewModel() {
        viewModel?.favoriteStoryObserve()
        viewModel?.state.bind { [weak self] state in
            guard let self else { return }
            switch state {
            case .initValue: Void()
            case .success(let data):
                if data.isEmpty {
                    self.mainView.showEmptyLabel()
                } else {
                    self.mainView.updateCountLabel(count: data.count)
                    self.mainView.favoriteStories = data
                }
                
            case .deleteUpdate(let data):

                if data.isEmpty {
                    self.mainView.showEmptyLabel()
                    AVPlayerManager.shared.stop()
                    mainView.playerBottomView.resetData()
                } else {
                    
                    self.mainView.updateCountLabel(count: data.count)
                    self.mainView.favoriteStories = data.map { story in
                        story.isPlaying = false
                        if story.audioURL == self.currentPlayingAudioURL {
                            story.isPlaying = true
                        }
                        return story
                    }
                    
                    let playItem = self.mainView.favoriteStories.first { $0.isPlaying }
                    guard let playItem else {
                        currentPlayingAudioURL = ""
                        AVPlayerManager.shared.stop()
                        mainView.playerBottomView.resetData()
                        return
                    }
                    currentPlayingAudioURL = playItem.audioURL
                }
                
            case .error(let msg):
                print(msg)
                self.showToast(msg: Strings.ErrorMsg.errorLoadingData)
            }
        }
    }
    
    func configureVC() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: .chevronBackward,
            style: .plain,
            target: self,
            action: #selector(backButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .txtPrimary
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.background
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.txtPrimary,
            .font: UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)
        ]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.backButtonDisplayMode = .minimal
        
        mainView.favoriteAudioGuideProtocol = self
        mainView.playerBottomView.playerBottomProtocol = self
        mainView.checkBoxView.delegate = self
        
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
    
    @objc private func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    //현재 진행중인 PlayerItem이 EndTime에 도달하면 호출
    @objc func playingMusicFinish(_ notification: Notification) {
        //필요한 정보나 객체가 있으면 object를 통해서 받아서 이용
        print("재생이 완료되었어요")
        AVPlayerManager.shared.stop()
        mainView.playerBottomView.resetData()
        
        if isContinuousPlay {
            let playItemIdx = mainView.favoriteStories.firstIndex { $0.isPlaying == true }
            guard let playItemIdx else { return }
            if playItemIdx < mainView.favoriteStories.count - 1 {
                let newPlayItem = mainView.favoriteStories[playItemIdx + 1]
                
                mainView.favoriteStories = mainView.favoriteStories.map {
                    $0.isPlaying = false
                    if $0 == newPlayItem {
                        $0.isPlaying = true
                    }
                    return $0
                }
                
                guard let url = URL(string: newPlayItem.audioURL) else { return }
                audioPlay(item: newPlayItem)
                updateData(item: newPlayItem)
                
            } else {
                
                // 마지막곡이 재생완료되면 처음부터 재생
                let newPlayItem = mainView.favoriteStories[0]
                
                mainView.favoriteStories = mainView.favoriteStories.map {
                    $0.isPlaying = false
                    if $0 == newPlayItem {
                        $0.isPlaying = true
                    }
                    return $0
                }
                audioPlay(item: newPlayItem)
                updateData(item: newPlayItem)
            }
            
            
        } else {
            if !mainView.favoriteStories.isEmpty {
                mainView.favoriteStories = mainView.favoriteStories.map {
                    $0.isPlaying = false
                    return $0
                }
                MPRemoteCommandCenterManager.shared.unregisterRemoteCenter()
            }
        }
        
    }
    
    private func audioPlay(item: FavoriteStory) {
        guard let audioURL = URL(string: item.audioURL) else { return }
        let audioItem = AudioItem(audioUrl: audioURL, title: item.audioTitle, imagePath: item.imageURL)
        currentPlayingAudioURL = item.audioURL
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.play(item: audioItem)
        AVPlayerManager.shared.addPlayTimeObserver(item: audioItem) { duration, interval, playTime in
            self.mainView.playerBottomView.audioSlider.value = interval
        }
    }
    
    private func updateData(item: FavoriteStory) {
        mainView.playerBottomView.thumbImageView.isHidden = false
        self.mainView.playerBottomView.updateData(
            title: item.audioTitle,
            thumbnail: item.imageURL
        )
        self.mainView.scriptView.updateData(
            title: item.audioTitle,
            script: item.script
        )
    }
    
    private func currentPlayingItemIndex() -> Int? {
        guard let playItem = mainView.favoriteStories.filter({ $0.isPlaying == true }).first,
              let index = mainView.favoriteStories.firstIndex(of: playItem) else {
            return nil
        }
        return index
    }
}

extension FavoriteAudioGuideVC: PlayerBottomProtocol {
    func previousClicked() {
        guard let currentIndex = currentPlayingItemIndex() else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        
        if currentIndex == 0 {
            
            if isContinuousPlay {
                // 첫번째 아이템에서 이전버튼 클릭시 마지막아이템으로 이동
                let lastPlayItem = mainView.favoriteStories[mainView.favoriteStories.count - 1]
                audioPlay(item: lastPlayItem)
                updateData(item: lastPlayItem)
                mainView.favoriteStories = mainView.favoriteStories.map {
                    $0.isPlaying = false
                    if $0 == lastPlayItem {
                        $0.isPlaying = true
                    }
                    return $0
                }
                
            } else {
                showToast(msg: Strings.ErrorMsg.errorFirstStory)
            }
            
        } else {
            let previousItemIndex = currentIndex - 1
            let previousPlayItem = mainView.favoriteStories[previousItemIndex]
            audioPlay(item: previousPlayItem)
            updateData(item: previousPlayItem)
            mainView.favoriteStories = mainView.favoriteStories.map {
                $0.isPlaying = false
                if $0 == previousPlayItem {
                    $0.isPlaying = !previousPlayItem.isPlaying
                }
                return $0
            }
        }
    }
    
    func nextClicked() {
        guard let currentIndex = currentPlayingItemIndex() else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        
        if currentIndex == mainView.favoriteStories.count - 1 {
            
            if isContinuousPlay {
                // 마지막 아이템에서 이전버튼 클릭시 첫 아이템으로 이동
                let firstPlayItem = mainView.favoriteStories[0]
                audioPlay(item: firstPlayItem)
                updateData(item: firstPlayItem)
                mainView.favoriteStories = mainView.favoriteStories.map {
                    $0.isPlaying = false
                    if $0 == firstPlayItem {
                        $0.isPlaying = true
                    }
                    return $0
                }
                
            } else {
                showToast(msg: Strings.ErrorMsg.errorLastStory)
            }
            
        } else {
            let nextItemIndex = currentIndex + 1
            let nextPlayItem = mainView.favoriteStories[nextItemIndex]
            audioPlay(item: nextPlayItem)
            updateData(item: nextPlayItem)
            mainView.favoriteStories = mainView.favoriteStories.map {
                $0.isPlaying = false
                if $0 == nextPlayItem {
                    $0.isPlaying = !nextPlayItem.isPlaying
                }
                return $0
            }
        }
    }
    
    func playAndPauseClicked() {
        let playItem = mainView.favoriteStories.filter { $0.isPlaying == true }.first
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

extension FavoriteAudioGuideVC: CheckBoxDelegate {
    func checkBoxClicked(isChecked: Bool) {        
        mainView.checkBoxView.updateCheckboxImage(checked: !isChecked)
        isContinuousPlay = !isChecked
    }
}

extension FavoriteAudioGuideVC: FavoriteAudioGuideVCProtocol {
    
    func cellHeartButtonClicked(item: FavoriteStory) {
        showAlert(
            title: "",
            msg: Strings.Common.alertMsgDeleteStoryItem,
            ok: Strings.Common.ok,
            no: Strings.Common.cancel
        ) { [weak self] _ in
            self?.viewModel?.deleteFavoriteStory(item: item)
        }
    }
    
    func didSelectItemAt(item: FavoriteStory) {
        // 재생시키기
        mainView.favoriteStories = mainView.favoriteStories.map {
            $0.isPlaying = false
            if $0 == item {
                $0.isPlaying = !item.isPlaying
            }
            return $0
        }
        
        guard let playItem = mainView.favoriteStories.filter({ $0.isPlaying == true }).first else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        audioPlay(item: playItem)
        updateData(item: playItem)
    }
    
}

extension FavoriteAudioGuideVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
