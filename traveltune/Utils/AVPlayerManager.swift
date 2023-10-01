//
//  AVPlayerManager.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/24.
//

import Foundation
import AVFoundation

final class AVPlayerManager: NSObject {
    
    static var shared = AVPlayerManager()
    private override init() {}
    
    private var player: AVPlayer? = nil
    
    private var playerItemContext = 0
    
    private var timeObserverToken: Any?
    
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
    
    func play(url: URL) {
        do {
            player?.pause()
            player = nil
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            player = AVPlayer(url: url)
            if let player {
                player.allowsExternalPlayback = true                       // 플레이어가 외부 재생 모드로 전환할 수 있는지 여부를 나타내는 Bool
                player.appliesMediaSelectionCriteriaAutomatically = true
                player.automaticallyWaitsToMinimizeStalling = true          // 재생이 끊기는 것을 최소화하기 위해 플레이어가 자동적으로 재생을 지연해야하는지 여부를 나타내는 Bool 값
                player.preventsDisplaySleepDuringVideoPlayback = true       // 비디오 재생이 디스플레이와 기기 잠자기 모드를 예방해야하는지를 가리키는 Bool 값
                player.volume = 1
                player.play()
            }
            
            //            let assets = AVAsset(url: url)
            //            let playerItem = AVPlayerItem(
            //                asset: assets,
            //                automaticallyLoadedAssetKeys: ["playable","hasProtectedContent"]
            //            )
            //
            //            playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
            //            player = AVPlayer(playerItem: playerItem)
            
        } catch let error {
            // 에러일 때 어떤식으로 처리할지 ?
            print("Error in AVAudio Session\(error.localizedDescription)")
        }
    }
    
    // 나만의 이야기에서 테스트 필요
    func playList(urls: [URL]) {
        player?.pause()
        player = nil
        
        do {
            var playItem = [AVPlayerItem]()
            urls.forEach { url in
                playItem.append(AVPlayerItem(url: url))
            }
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            player = AVQueuePlayer(items: playItem)
            if let player {
                player.allowsExternalPlayback = true                       // 플레이어가 외부 재생 모드로 전환할 수 있는지 여부를 나타내는 Bool
                player.appliesMediaSelectionCriteriaAutomatically = true
                player.automaticallyWaitsToMinimizeStalling = true          // 재생이 끊기는 것을 최소화하기 위해 플레이어가 자동적으로 재생을 지연해야하는지 여부를 나타내는 Bool 값
                player.preventsDisplaySleepDuringVideoPlayback = true       // 비디오 재생이 디스플레이와 기기 잠자기 모드를 예방해야하는지를 가리키는 Bool 값
                player.volume = 1
                player.play()
            }
            
        } catch let error {
            // 에러일 때 어떤식으로 처리할지 ?
            print("Error in AVAudio Session\(error.localizedDescription)")
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func replay() {
        player?.play()
    }
    
    func stop() {
        player?.pause()
        player = nil
    }
    
    func resetSeek() {
        player?.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 1))
    }
    
    func addPlayTimeObserver(listener: @escaping (Float, Float64) -> Void) {
        let time = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] progressTime in
            //현재 진행된 progressTime 을 '초'로 변경
            let seconds = CMTimeGetSeconds(progressTime)
            if let duration = self?.player?.currentItem?.duration{
                let durationSeconds = CMTimeGetSeconds(duration)
                listener(Float(seconds / durationSeconds), seconds)
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
