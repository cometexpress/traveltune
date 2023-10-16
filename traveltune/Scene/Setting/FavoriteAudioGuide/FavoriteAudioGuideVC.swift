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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
        
        // 재생완료시점 확인용
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playingMusicFinish(_:)),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.topItem?.title = naviTitle
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        if !mainView.favoriteStories.isEmpty {
            mainView.favoriteStories = mainView.favoriteStories.map {
                $0.isPlaying = false
                return $0
            }
        }
    }
    
    private func audioPlay(url: URL) {
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.play(url: url)
        AVPlayerManager.shared.addPlayTimeObserver { interval, playTime in
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
}

extension FavoriteAudioGuideVC: PlayerBottomProtocol {
    func previousClicked() {
        
    }
    
    func nextClicked() {
        
    }
    
    func playAndPauseClicked() {
        
    }
    
    func thumbImageClicked() {
        if mainView.scriptView.isHidden {
            mainView.showScriptView()
        } else {
            mainView.hideScriptView()
        }
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
        
        guard let playItem = mainView.favoriteStories.filter({ $0.isPlaying == true }).first,
              let audioURL = URL(string: playItem.audioURL) else {
            AVPlayerManager.shared.stop()
            self.mainView.playerBottomView.resetData()
            return
        }
        audioPlay(url: audioURL)
        updateData(item: playItem)
        currentPlayingAudioURL = playItem.audioURL
    }
    
}

extension FavoriteAudioGuideVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
