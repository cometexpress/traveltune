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
                player.allowsExternalPlayback = true
                player.appliesMediaSelectionCriteriaAutomatically = true
                player.automaticallyWaitsToMinimizeStalling = true
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
