//
//  AVPlayerManager.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/24.
//

import AVFoundation
import UIKit
import MediaPlayer
import Kingfisher

struct AudioItem {
    let audioUrl: URL
    let title: String
    let imagePath: String
}

final class AVPlayerManager: NSObject {
    
    static let shared = AVPlayerManager()
    private override init() {}
    
    var player: AVPlayer? = nil
    
    private var playerItemContext = 0
    
    private var timeObserverToken: Any?
    
    // scene delegate 에서 값 전달시 사용
    enum RemotePlayerStatus: String {
        case play
        case stop
    }
    
    var status: PlayerStauts {
        switch player?.timeControlStatus {
        case .paused:
            return PlayerStauts.stop
        case .waitingToPlayAtSpecifiedRate:
            return PlayerStauts.waitingToPlay
        case .playing:
            return PlayerStauts.playing
        default:
            return PlayerStauts.stop
        }
    }
    
    func isFirstPlay() -> Bool {
        return player == nil ? true : false
    }
    
    func play(item: AudioItem) {
        do {
            player?.pause()
            player = nil
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            player = AVPlayer(url: item.audioUrl)
            if let player {
                player.allowsExternalPlayback = true                       // 플레이어가 외부 재생 모드로 전환할 수 있는지 여부를 나타내는 Bool
                player.appliesMediaSelectionCriteriaAutomatically = true
                player.automaticallyWaitsToMinimizeStalling = true          // 재생이 끊기는 것을 최소화하기 위해 플레이어가 자동적으로 재생을 지연해야하는지 여부를 나타내는 Bool 값
                player.preventsDisplaySleepDuringVideoPlayback = true       // 비디오 재생이 디스플레이와 기기 잠자기 모드를 예방해야하는지를 가리키는 Bool 값
                player.volume = 1
                player.play()
                
                MPRemoteCommandCenterManager.shared.registerRemoteCenterAction()
            }
            
        } catch let error {
            // 에러일 때 어떤식으로 처리할지 ?
            print("Error in AVAudio Session\(error.localizedDescription)")
        }
    }
    
    // 나만의 이야기에서 테스트 필요
    //    func playList(urls: [URL]) {
    //        player?.pause()
    //        player = nil
    //
    //        do {
    //            var playItem = [AVPlayerItem]()
    //            urls.forEach { url in
    //                playItem.append(AVPlayerItem(url: url))
    //            }
    //            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
    //            player = AVQueuePlayer(items: playItem)
    //            if let player {
    //                player.allowsExternalPlayback = true                       // 플레이어가 외부 재생 모드로 전환할 수 있는지 여부를 나타내는 Bool
    //                player.appliesMediaSelectionCriteriaAutomatically = true
    //                player.automaticallyWaitsToMinimizeStalling = true          // 재생이 끊기는 것을 최소화하기 위해 플레이어가 자동적으로 재생을 지연해야하는지 여부를 나타내는 Bool 값
    //                player.preventsDisplaySleepDuringVideoPlayback = true       // 비디오 재생이 디스플레이와 기기 잠자기 모드를 예방해야하는지를 가리키는 Bool 값
    //                player.volume = 1
    //                player.play()
    //            }
    //
    //        } catch let error {
    //            // 에러일 때 어떤식으로 처리할지 ?
    //            print("Error in AVAudio Session\(error.localizedDescription)")
    //        }
    //    }
    
    
    func pause() {
        player?.pause()
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0
    }
    
    func replay() {
        player?.play()
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1
    }
    
    func stop() {
        // remote command 이벤트 중단
        player?.pause()
        player = nil
    }
    
    func resetSeek() {
        player?.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 1))
    }
    
    func addPlayTimeObserver(item: AudioItem, listener: @escaping (CMTime, Float, Float64) -> Void) {
        let time = CMTime(seconds: 0.001, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] progressTime in
            //현재 진행된 progressTime 을 '초'로 변경
            let seconds = CMTimeGetSeconds(progressTime)
            if let duration = self?.player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                listener(duration, Float(seconds / durationSeconds), seconds)
                MPRemoteCommandCenterManager.shared.updateRemoteCenterInfo(item: item)
            }
        }
    }
    
    func removePlayTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    enum PlayerStauts {
        case playing
        case stop
        case waitingToPlay
    }
    
}
