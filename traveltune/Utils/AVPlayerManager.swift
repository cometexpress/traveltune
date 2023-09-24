//
//  AVPlayerManager.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/24.
//

import Foundation

import AVFoundation

final class AVPlayerManager {
    
    static var shared = AVPlayerManager()
    private var player = AVPlayer()
    
    private init() {}
    
    func play(url: URL) {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            
            player = AVPlayer(url: url)
            player.allowsExternalPlayback = true
            player.appliesMediaSelectionCriteriaAutomatically = true
            player.automaticallyWaitsToMinimizeStalling = true
            player.volume = 1
            player.play()
        } catch let error {
            // 에러일 때 어떤식으로 처리할지 ?
            print("Error in AVAudio Session\(error.localizedDescription)")
        }
    }
}
