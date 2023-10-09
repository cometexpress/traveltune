//
//  DetailStoryVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/09.
//

import Foundation

final class DetailStoryVC: BaseViewController<DetailStoryView, DetailStoryViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.stop()
    }
    
    func bindViewModel() {
        viewModel?.detailStory.bind { [weak self] item in
            guard let item else { return }
            print(item)
            self?.mainView.fetchData(item: item)
        }
    }
    
    func configureVC() {
        mainView.detailStoryProtocol = self
        
        // 재생완료시점 확인용
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playingMusicFinish(_:)),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }
    
    private func audioPlay(url: URL) {
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.play(url: url)
        AVPlayerManager.shared.addPlayTimeObserver { interval, playTime in
            let seconds = String(format: "%02d", Int(playTime) % 60)
            let minutes = String(format: "%02d", Int(playTime / 60))
            let intervalTime = "\(minutes):\(seconds)"
            self.mainView.intervalTimeLabel.text = intervalTime
            self.mainView.audioSlider.value = interval
        }
    }
    
    @objc func playingMusicFinish(_ notification: Notification) {
        //필요한 정보나 객체가 있으면 object를 통해서 받아서 이용
        print("재생이 완료되었어요")
        AVPlayerManager.shared.stop()
        mainView.resetAudio()
    }
}

extension DetailStoryVC: DetailStoryProtocol {
    
    func backButtonClicked() {
        dismiss(animated: true)
    }
    
    func playAndPauseClicked() {
        
        if AVPlayerManager.shared.isFirstPlay() {
            guard let url = URL(string: viewModel?.detailStory.value?.audioURL ?? "") else {
                showAlert(title: "", msg: Strings.Common.errorNoFile, ok: Strings.Common.ok)
                return
            }
            audioPlay(url: url)
            mainView.setPlayImageInAudio()
        } else {
            switch AVPlayerManager.shared.status {
            case .playing:  // 재생중일 때 누르면 할 일
                AVPlayerManager.shared.pause()
                mainView.resetAudio()
            case .stop:     // 멈춰있을 때 누르면 할 일
                AVPlayerManager.shared.replay()
                mainView.setPlayImageInAudio()
            case .waitingToPlay:
                print("로딩 중")
            }
        }
    }
    
    func likeViewClicked() {
        print("좋아요 클릭")
    }
    
    func shareViewClicked() {
        print("공유 클릭")
    }
}
