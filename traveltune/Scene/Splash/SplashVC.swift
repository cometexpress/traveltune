//
//  SplashVC.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/27.
//

import UIKit
import RealmSwift
import Toast

final class SplashVC: BaseViewController<SplashView> {
    
    private let viewModel = SplashViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureVC() {
     
        let fileURL = Realm.Configuration.defaultConfiguration.fileURL
        print(fileURL)
        
        // TODO: UserDefaults 로 유저 앱 실행시간 저장 코드 추가 필요
        // TODO: 한국어, 영어 모두 저장 필요
        
        // 1. 신규 유저
        // TODO: 관광지 기본정보 모든 데이터 불러올 때까지 반복 Request 날리기 [o]
        // TODO: 모든 정보 불러왔으면 Realm 에 데이터 저장 [o]
        viewModel.updateTravelSpots(language: .ko) { [weak self] in
            self?.showToast(msg: "오류 발생")
        }
        
        // 2. 기존 유저
        // TODO: 유저가 앱에 들어온 시간 비교해서 2주 지났을 때만 데이터 업데이트 시키기
        
     
    }
}
