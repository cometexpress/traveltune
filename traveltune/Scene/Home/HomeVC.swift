//
//  HomeVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/22.
//

import UIKit

final class HomeVC: BaseViewController<HomeView> {
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIFont.familyNames.sorted().forEach { familyName in
            print("*** \(familyName) ***")
            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                print("\(fontName)")
            }
            print("---------------------")
        }
        
        viewModel.themes.bind { [weak self] themes in
            self?.mainView.themes.append(contentsOf: themes)
        }
        
        viewModel.updateThemes()
        
        // 재생완료시점 확인용
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playingMusicFinish(_:)),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        
//        let testURL = URL(string: "https://sfj608538-sfj608538.ktcdn.co.kr/file/audio/56/7237.mp3")!
//        AVPlayerManager.shared.play(url: testURL)
//        AVPlayerManager.shared.playTimeObserver { interval, playTime in
//            let seconds = String(format: "%02d", Int(playTime) % 60)
//            let minutes = String(format: "%02d", Int(playTime / 60))
//            print("interval = \(interval)")
//            print("\(minutes):\(seconds)")
//        }
        
//        Network.shared.request(
//            api: .baseSpots(request: RequestTravelSpots(
//                numOfRows: "10",
//                pageNo: "1",
//                langCode: "ko")
//            ),
//            type: ResponseTravelSpots.self) { response in
//                switch response {
//                case .success(let success):
//                    print(success)
//                case .failure(let failure):
//                    print(failure)
//                }
//            }
        
        Network.shared.request(
            api: .checkVisitorsInMetro(request: RequestCheckVisitorsInMetro(
                pageNo: "1",
                numOfRows: "10",
                startYmd: "20210513",
                endYmd: "20210513")
            ), type: ResponseCheckVisitorsInMetros.self) { response in
                switch response {
                case .success(let success):
                    print(success)
                case .failure(let failure):
                    print(failure)
                }
            }
    }
    
    //현재 진행중인 PlayerItem이 EndTime에 도달하면 호출
    @objc func playingMusicFinish(_ notification: Notification) {
        //필요한 정보나 객체가 있으면 object를 통해서 받아서 이용
        print("재생이 완료되었어요")
    }
    
    @objc func searchButtonClicked() {
        print("검색버튼 클릭")
    }
    
    override func configureVC() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .magnifyingglass.withTintColor(.txtSecondary, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(searchButtonClicked)
        )
        
        navigationController?.navigationBar.topItem?.title = Strings.Common.logoTitle
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.txtPrimary,
            NSAttributedString.Key.font: UIFont(name: Fonts.logo, size: 12)!
        ]
    }
}
