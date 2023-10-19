//
//  MPRemoteCommandCenterManager.swift
//  traveltune
//
//  Created by 장혜성 on 2023/10/19.
//

import Foundation
import MediaPlayer
import Kingfisher

final class MPRemoteCommandCenterManager {
    static let shared = MPRemoteCommandCenterManager()
    private init() { }
    
    private let center = MPRemoteCommandCenter.shared()
    
    func registerRemoteCenterAction(player: AVPlayer) {
//        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        // 이전에 등록된 버튼에 대한 액션 제거 - 하지않으면 동시에 여러개 파일이 재생되는 현상발생
        print("removeTarget 실행")
        center.playCommand.removeTarget(nil)
        center.pauseCommand.removeTarget(nil)
        
        center.playCommand.isEnabled = true
        center.pauseCommand.isEnabled = true
        
        center.playCommand.addTarget { event in
            player.play()
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime().seconds
            // 시간이 흐르게 설정
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1
            return .success
        }
        
        center.pauseCommand.addTarget { event in
            player.pause()
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime().seconds
            // 시간이 안흐르게 설정
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0
            return .success
        }
    }
    
    func updateRemoteCenterInfo(item: AudioItem) {
        guard let player = AVPlayerManager.shared.player else { return }
        let center = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = center.nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = item.title
        
        let placeholderImage = UIImage(named: "logo")
        
        if let thumbnailURL = URL(string: item.imagePath) {
            //                    let resource = ImageResource(downloadURL: thumbnailURL)
            KingfisherManager.shared.retrieveImage(with: thumbnailURL) { result in
                switch result {
                case .success(let imageResult):
                    let artwork = MPMediaItemArtwork(boundsSize: imageResult.image.size) { size in
                        return imageResult.image
                    }
                    nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                case .failure(let error):
                    print("이미지를 불러오는데 실패, ", error.localizedDescription)
                    if let mainLogo = placeholderImage {
                        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: mainLogo.size, requestHandler: { size in
                            return mainLogo
                        })
                    }
                }
            }
            
        } else {
            if let mainLogo = placeholderImage {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: mainLogo.size, requestHandler: { size in
                    return mainLogo
                })
            }
        }
        
        // 콘텐츠 총 길이
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Float(player.currentItem?.duration.seconds ?? 0)
        // 콘텐츠 재생 시간에 따른 progressBar 초기화
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        // 콘텐츠 현재 재생시간
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Float(player.currentItem?.currentTime().seconds ?? 0)
        center.nowPlayingInfo = nowPlayingInfo
    }
    
    func unregisterRemoteCenter() {
        // removeTarget(nil) 안해주면 여러 파일 재생후 잠금화면에서 다시 재생시키면 동시에 여러파일 재생됨
        center.playCommand.removeTarget(nil)
        center.pauseCommand.removeTarget(nil)
        center.playCommand.isEnabled = false
        center.pauseCommand.isEnabled = false
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
}
