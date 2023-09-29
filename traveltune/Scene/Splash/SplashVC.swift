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
        
        NetworkMonitor.shared.startMonitoring(statusUpdateHandler: { [weak self] connectionStatus in
            switch connectionStatus {
            case .satisfied:
                let visitDate = UserDefaults.visitDate
                if visitDate.isEmpty {
                    // 1. 신규 유저 일 때
                    // 접속 날짜 UserDefault 에 저장
                    // 관광지 기본정보 모든 데이터 불러올 때까지 반복 Request 요청
                    // 한국어, 영어 모두 불러오기
                    // 모든 정보 불러왔으면 Realm 에 저장
                    UserDefaults.visitDate = Date().basic
                    self?.updateBindData()
                } else {
                    // 2. 기존 유저
                    // 유저가 앱에 들어온 시간 비교해서 2주 지났을 때만 기존 데이터 삭제 후 데이터 업데이트 시키기
                    let today = Date().basic
                    print("오늘 날짜 = ", today)
                    print("방문했던 날짜 = ", UserDefaults.visitDate)
                    
                    let testEndDate = "2025-12-12"
                    
                    self?.viewModel.compareToDateTheDay(start: UserDefaults.visitDate, end: today)
                    UserDefaults.visitDate = Date().basic
                    
                    self?.viewModel.compareDay.bind { [weak self] days in
                        if days <= self?.viewModel.maximumDays ?? 0 {
                            self?.moveTabBarVC()
                        } else {
                            print("데이터 업데이트 필요")
                            self?.viewModel.removeAllSpot()
                        }
                    }
                    
                    self?.viewModel.isDelete.bind { [weak self] isSuccess in
                        if isSuccess {
                            self?.updateBindData()
                        } else {
                            self?.showToast(msg: Strings.ErrorMsg.errorRestartApp)
                        }
                    }
                }
                
            case .unsatisfied, .requiresConnection:
                self?.showAlert(title: "", msg: Strings.ErrorMsg.errorNetwork, ok: Strings.Common.ok)
            @unknown default:
                self?.showAlert(title: "", msg: Strings.ErrorMsg.errorRestartApp, ok: Strings.Common.ok)
            }
            
        })
        
        
        
    }
    
    private func updateBindData() {
        viewModel.updateAllLangTravelSpots()
        viewModel.isLoading.bind { [weak self] loading in
            if loading {
                self?.mainView.indicatorView.startAnimating()
            } else {
                self?.viewModel.saveTravelSpots()
            }
        }
        viewModel.updateKoreaData.bind { isKoreaData in
            UserDefaults.updateKoreaTravelSpots = isKoreaData
        }
        viewModel.updateEnglishData.bind { isEnglishData in
            UserDefaults.updateKoreaTravelSpots = isEnglishData
        }
        viewModel.isComplete.bind { [weak self] complete in
            if complete {
                self?.mainView.indicatorView.stopAnimating()
                self?.moveTabBarVC()
            }
        }
    }
    
    private func moveTabBarVC() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = TabBarVC()
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
}
