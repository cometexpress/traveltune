//
//  DetailStoryVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/09.
//

import Foundation
import LinkPresentation

final class DetailStoryVC: BaseViewController<DetailStoryView, DetailStoryViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureVC()
        
        if self.modalPresentationStyle == .fullScreen {
            mainView.backButton.isHidden = false
        } else {
            mainView.backButton.isHidden = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.stop()
    }
    
    func bindViewModel() {
        viewModel?.detailStory.bind { [weak self] item in
            guard let item else { return }
            self?.mainView.fetchData(item: item)
            self?.viewModel?.favoriteStoryObserve()
        }
        
        viewModel?.likeStatus.bind { [weak self] isLike in
            self?.mainView.setLikeImage(isLike: isLike)
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
                mainView.playView.setView(backgroundColor: .backgroundButton, image: .pauseFill)
            case .stop:
                mainView.playView.setView(backgroundColor: .backgroundButton, image: .playFill)
            case nil:
                print("error")
            }
        }
    }
    
    private func audioPlay(item: StoryItem) {
        guard let url = URL(string: item.audioURL) else { return }
        let audioItem = AudioItem(audioUrl: url, title: item.audioTitle, imagePath: item.imageURL)
        AVPlayerManager.shared.removePlayTimeObserver()
        AVPlayerManager.shared.play(item: audioItem)
        AVPlayerManager.shared.addPlayTimeObserver(item: audioItem) { duration, interval, playTime in
            let seconds = String(format: "%02d", Int(playTime) % 60)
            let minutes = String(format: "%02d", Int(playTime / 60))
            let intervalTime = "\(minutes):\(seconds)"
            
            /**
             서버에서 주는 playTime 과 파일재생시간이 다른 경우가 있는데
             재생했을 때만 현재아이템의 길이를 파악할 수 있어서 이 방법도 아닌듯 하지만...
             상세 페이지이기에 여기는 재생될 때 바뀌도록 다른 리스트가 있는 재생화면과 다르게 동작
             */
            guard !(duration.roundedSeconds.isNaN) else {
                return
            }
            self.mainView.playTimeLabel.text = duration.positionalTime
            self.mainView.intervalTimeLabel.text = intervalTime
            self.mainView.audioSlider.value = interval
        }
    }
    
    // Link Presentation 공유
    private func showShareLinkPresentation(url: URL) {
//        let imgURL = URL(string: "......")
//        let shareLinkPresentation = ShareableLinkPresentation(title: Constant.productName, shareURL: url, imgURL: imgURL)
//        let shareVC = UIActivityViewController(activityItems: [shareLinkPresentation], applicationActivities: nil)
//        present(shareVC, animated: true)
    }
    
    private func shareImage(imgURL: URL) {
        let shareVC = UIActivityViewController(activityItems: [imgURL], applicationActivities: nil)
        shareVC.excludedActivityTypes = [
            .airDrop,
            .postToFacebook,
            .postToTwitter,
            .markupAsPDF
        ]
        present(shareVC, animated: true)
    }
    
    private func shareAudio(audioURL: URL) {
        let shareVC = UIActivityViewController(activityItems: [audioURL], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        shareVC.excludedActivityTypes = [
            .airDrop,
            .postToFacebook,
            .postToTwitter,
            .markupAsPDF
        ]
        present(shareVC, animated: true)
    }
    
    //    private func showShareSheet(metaData: LPLinkMetadata) {
    //        let shareText: String = "share text test!"
    //        var shareObject = [Any]()
    //
    //        shareObject.append(shareText)
    //
    //        let activityViewController = UIActivityViewController(activityItems : [metaData], applicationActivities: nil)
    //        activityViewController.popoverPresentationController?.sourceView = self.view
    //
    //        activityViewController.excludedActivityTypes = [
    //            .airDrop,
    //            .postToFacebook,
    //            .postToTwitter,
    //            .markupAsPDF
    //        ]
    //        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
    //            if success {
    //                self.showToast(msg: "성공")
    //            } else {
    //                print(error?.localizedDescription)
    //                self.showToast(msg: "오류")
    //            }
    //        }
    //        self.present(activityViewController, animated: true, completion: nil)
    //    }
    
    
    @objc func playingMusicFinish(_ notification: Notification) {
        //필요한 정보나 객체가 있으면 object를 통해서 받아서 이용
        print("재생이 완료되었어요")
        AVPlayerManager.shared.stop()
        mainView.resetAudio()
        MPRemoteCommandCenterManager.shared.unregisterRemoteCenter()
    }
}

extension DetailStoryVC: DetailStoryProtocol {
    
    func backButtonClicked() {
        dismiss(animated: true)
    }
    
    func playAndPauseClicked() {
        
        if AVPlayerManager.shared.isFirstPlay() {
            guard let _ = URL(string: viewModel?.detailStory.value?.audioURL ?? "") else {
                showAlert(title: "", msg: Strings.ErrorMsg.errorNoFile, ok: Strings.Common.ok)
                return
            }
            audioPlay(item: (viewModel?.detailStory.value)!)
            mainView.playView.setView(backgroundColor: .backgroundButton, image: .pauseFill)
        } else {
            switch AVPlayerManager.shared.status {
            case .playing:  // 재생중일 때 누르면 할 일
                AVPlayerManager.shared.pause()
                mainView.playView.setView(backgroundColor: .backgroundButton, image: .playFill)
            case .stop:     // 멈춰있을 때 누르면 할 일
                AVPlayerManager.shared.replay()
                mainView.playView.setView(backgroundColor: .backgroundButton, image: .pauseFill)
            case .waitingToPlay:
                print("로딩 중")
            }
        }
    }
    
    func likeViewClicked() {
        guard let _ = URL(string: viewModel?.detailStory.value?.audioURL ?? "") else {
            showAlert(title: "", msg: Strings.ErrorMsg.errorNoFile, ok: Strings.Common.ok)
            return
        }
        
        if viewModel?.likeStatus.value == true {
            viewModel?.deleteFavoriteStory()
        } else {
            viewModel?.addFavoriteStory()
        }
    }
    
    func shareViewClicked() {
        guard let url = URL(string: viewModel?.detailStory.value?.audioURL ?? "") else {
            showAlert(title: "", msg: Strings.ErrorMsg.errorNoFile, ok: Strings.Common.ok)
            return
        }
        shareAudio(audioURL: url)
    }
}
